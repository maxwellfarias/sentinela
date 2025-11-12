import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/domain/models/documento_base64/documento_base64_model.dart';
import 'package:w3_diploma/utils/command.dart';
import '../extensions/build_context_extension.dart';

/// Widget reutilizável para upload e visualização de documentos em Base64
///
/// Permite:
/// - Upload de arquivos PDF com conversão para Base64
/// - Visualização de documentos já anexados (local ou servidor)
/// - Substituição de documentos
/// - Validação de obrigatoriedade
/// - Indicadores visuais de status
class DocumentUploadField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final bool hasFile;
  final TextEditingController controller;
  final String? currentFileName;
  final VoidCallback? onFileSelected;
  final String? Function(String?)? validator;

  // Parâmetros para buscar documento do servidor
  final Command1<DocumentoBase64Model, ({String alunoID, TipoDocumentoBase64 documento})>? getDocumentoBase64Command;
  final String? alunoId;
  final TipoDocumentoBase64? tipoDocumento;

  const DocumentUploadField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hasFile = false,
    required this.controller,
    this.currentFileName,
    this.onFileSelected,
    this.validator,
    this.getDocumentoBase64Command,
    this.alunoId,
    this.tipoDocumento,
  });

  @override
  State<DocumentUploadField> createState() => _DocumentUploadFieldState();
}

class _DocumentUploadFieldState extends State<DocumentUploadField> {
  final FilePicker _picker = FilePicker.platform;
  String? _selectedFileName;
  bool hasFile = false;

  @override
  void initState() {
    super.initState();
    hasFile = widget.hasFile;
    _selectedFileName = widget.currentFileName;
  }

  Future<void> _pickFile() async {
    try {
      // Permite selecionar o PDF
      final FilePickerResult? pickedFile = await _picker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (pickedFile != null) {
        final file = pickedFile.files.first;
        if (file.extension  != 'pdf') {
          _showError('Formato de arquivo inválido. Apenas PDF é permitido.');
          return;
        }
        
        // Validação de tamanho (máximo 3MB)
        final fileSizeInMB = (file.size) / (1024 * 1024);
        if (fileSizeInMB > 3) {
          _showError('Arquivo muito grande. Tamanho máximo: 3MB. Tamanho do arquivo: ${fileSizeInMB.toStringAsFixed(2)}MB');
          return;
        }

          
          final bytes = file.bytes;
          if (bytes == null) {
            _showError('Erro ao ler o arquivo');
            return;
          }

       final base64String = base64Encode(bytes);

        if (mounted) {
          setState(() {
            widget.controller.text = base64String;
            _selectedFileName = file.name;
            hasFile = true;
          });

          widget.onFileSelected?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('Erro ao selecionar arquivo: $e');
      }
    }
  }

  void _removeFile() {
    setState(() {
      widget.controller.clear();
      _selectedFileName = null;
      hasFile = false;
    });
  }

  void _viewFile() {
    // Se o controller tem conteúdo local, mostra diretamente
    if (widget.controller.text.isNotEmpty) {
      _showLocalDocument();
      return;
    }

    // Se tem command para buscar do servidor, usa-o
    if (widget.getDocumentoBase64Command != null &&
        widget.alunoId != null &&
        widget.tipoDocumento != null) {
      _showServerDocument();
      return;
    }

    _showError('Nenhum documento disponível para visualização');
  }

  void _showLocalDocument() {
    try {
      final bytes = base64Decode(widget.controller.text);

      // Mostra dialog com preview do PDF
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: context.customColorTheme.card,
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(maxHeight: 800, maxWidth: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.customColorTheme.border,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.label,
                          style: context.customTextTheme.textLgSemibold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Preview
                Expanded(child: _buildPdfPreview(bytes)),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      _showError('Erro ao visualizar documento: $e');
    }
  }

  void _showServerDocument() {
    final command = widget.getDocumentoBase64Command!;
    command.execute((
      alunoID: widget.alunoId!,
      documento: widget.tipoDocumento!,
    ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: context.customColorTheme.card,
        child: ListenableBuilder(
          listenable: command,
          builder: (_, __) {
            // Estado de carregamento
            if (command.running) {
              return _buildLoadingState();
            }

            // Estado de erro
            if (command.error) {
              return _buildErrorState(command.errorMessage);
            }

            // Estado de sucesso
            if (command.completed && command.value != null) {
              return _buildSuccessState(command.value!);
            }

            // Estado inicial/default
            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildPdfPreview(List<int> bytes) {
    return Column(
      children: [
        Expanded(
          child: PdfPreview(
            allowPrinting: false,
            allowSharing: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            build: (format) async => Uint8List.fromList(bytes),
            pdfFileName: _selectedFileName ?? 'documento.pdf',
            actions: [
              PdfShareAction(
                icon: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Baixar documento',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.download,
                        color: context.colorTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onError: (_,__) => _buildErrorState('Erro ao renderizar o PDF'),
          ),
        ),
      ],
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.customColorTheme.destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              widget.isRequired ? '${widget.label} *' : widget.label,
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.foreground,
              ),
            ),
            const SizedBox(height: 8),
            
            // Card do documento
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.customColorTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: formFieldState.hasError
                      ? context.customColorTheme.destructive
                      : context.customColorTheme.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Ícone de status
                  Icon(
                    hasFile ? Icons.check_circle : Icons.attach_file,
                    color: hasFile
                        ? context.customColorTheme.success
                        : context.customColorTheme.mutedForeground,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  
                  // Nome do arquivo ou placeholder
                  Expanded(
                    child: Text(
                      _selectedFileName ?? 'Nenhum arquivo selecionado',
                      style: context.customTextTheme.textSm.copyWith(
                        color: hasFile
                            ? context.customColorTheme.foreground
                            : context.customColorTheme.mutedForeground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Botões de ação
                  if (hasFile) ...[
                    // Botão visualizar
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: _viewFile,
                      tooltip: 'Visualizar',
                      style: IconButton.styleFrom(
                        foregroundColor: context.customColorTheme.primary,
                      ),
                    ),
                    
                    // Botão remover
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: _removeFile,
                      tooltip: 'Remover',
                      style: IconButton.styleFrom(
                        foregroundColor: context.customColorTheme.destructive,
                      ),
                    ),
                  ],
                  
                  // Botão selecionar/substituir
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: Icon(
                      hasFile ? Icons.refresh : Icons.upload_file,
                      size: 18,
                    ),
                    label: Text(
                      hasFile ? 'Substituir' : 'Selecionar',
                      style: context.customTextTheme.textSmMedium,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.customColorTheme.primary,
                      foregroundColor: context.customColorTheme.primaryForeground,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Mensagem de erro
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  formFieldState.errorText!,
                  style: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.destructive,
                  ),
                ),
              ),
            
            // Texto de ajuda
            if (!formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  'Formato aceito: PDF. Tamanho máximo: 3MB',
                  style: context.customTextTheme.textXs.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ========== ESTADOS DO DIALOG DE VISUALIZAÇÃO DO SERVIDOR ==========

  Widget _buildLoadingState() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 500),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: context.customTextTheme.textLgSemibold.copyWith(
                    color: context.customColorTheme.cardForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Progress Bar Customizada
          _ModernProgressBar(
            primaryColor: context.customColorTheme.primary,
            backgroundColor: context.customColorTheme.muted,
          ),

          const SizedBox(height: 24),

          Text(
            'Carregando documento...',
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 500),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: context.customTextTheme.textLgSemibold.copyWith(
                    color: context.customColorTheme.cardForeground,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Ícone de erro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.customColorTheme.destructive.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: context.customColorTheme.destructive,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Erro ao carregar documento',
            style: context.customTextTheme.textLgSemibold.copyWith(
              color: context.customColorTheme.cardForeground,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            errorMessage ?? 'Ocorreu um erro desconhecido',
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Botão de fechar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.customColorTheme.primary,
                foregroundColor: context.customColorTheme.primaryForeground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Fechar',
                style: context.customTextTheme.textSmMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(DocumentoBase64Model documento) {
    final bytes = base64Decode(documento.base64Conteudo);

    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxHeight: 800, maxWidth: 800),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.customColorTheme.border,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: context.customTextTheme.textLgSemibold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Preview
          Expanded(child: _buildPdfPreview(bytes)),
        ],
      ),
    );
  }
}

/// Widget de Progress Bar customizada e moderna
/// Carrega até ~90% e depois mantém a animação em loop
class _ModernProgressBar extends StatefulWidget {
  final Color primaryColor;
  final Color backgroundColor;

  const _ModernProgressBar({
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  State<_ModernProgressBar> createState() => _ModernProgressBarState();
}

class _ModernProgressBarState extends State<_ModernProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Animação que vai até 0.88 (88%) e depois fica oscilando
    _progressAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.88)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.88, end: 0.90)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.90, end: 0.88)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15.0,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Barra de progresso
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                // Background da barra
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Progresso com gradiente
                FractionallySizedBox(
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.primaryColor,
                          widget.primaryColor.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Efeito de brilho
                FractionallySizedBox(
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.3),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Porcentagem
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            final percentage = (_progressAnimation.value * 100).toInt();
            return Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
