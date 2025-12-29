import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import '../../../../domain/models/policial_militar/policial_militar_model.dart';

/// Tipo de venda/operação do militar
enum TipoOperacao { apenas_interno, apenas_externo, interno_e_externo }

extension TipoOperacaoExtension on TipoOperacao {
  String get displayName {
    switch (this) {
      case TipoOperacao.apenas_interno:
        return 'Apenas interno';
      case TipoOperacao.apenas_externo:
        return 'Apenas externo';
      case TipoOperacao.interno_e_externo:
        return 'Interno e externo';
    }
  }
}

/// Dialog para adicionar ou editar um militar
///
/// Baseado no design do Flowbite "Add Product" modal.
/// Pode ser usado tanto para criar quanto para editar um militar existente.
class MilitarFormDialog extends StatefulWidget {
  /// Militar a ser editado. Se null, é modo de criação.
  final PolicialMilitarModel? militar;

  /// Callback chamado quando o formulário é salvo com sucesso
  final void Function(PolicialMilitarModel militar)? onSave;

  /// Callback chamado quando o agendamento é solicitado
  final void Function(PolicialMilitarModel militar)? onSchedule;

  const MilitarFormDialog({
    super.key,
    this.militar,
    this.onSave,
    this.onSchedule,
  });

  /// Método estático para exibir o dialog
  static Future<void> show({
    required BuildContext context,
    PolicialMilitarModel? militar,
    void Function(PolicialMilitarModel militar)? onSave,
    void Function(PolicialMilitarModel militar)? onSchedule,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MilitarFormDialog(
        militar: militar,
        onSave: onSave,
        onSchedule: onSchedule,
      ),
    );
  }

  @override
  State<MilitarFormDialog> createState() => _MilitarFormDialogState();
}

class _MilitarFormDialogState extends State<MilitarFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos de texto
  late final TextEditingController _nomeGuerraController;
  late final TextEditingController _nomeCompletoController;
  late final TextEditingController _matriculaController;
  late final TextEditingController _pontosController;
  late final TextEditingController _pesoController;
  late final TextEditingController _alturaController;
  late final TextEditingController _larguraController;
  late final TextEditingController _comprimentoController;
  late final TextEditingController _descricaoController;

  // Estado dos campos
  Graduacao? _selectedGraduacao;
  TipoOperacao _selectedTipoOperacao = TipoOperacao.apenas_interno;

  bool get _isEditing => widget.militar != null;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final militar = widget.militar;

    _nomeGuerraController = TextEditingController(
      text: militar?.nomeGuerra ?? '',
    );
    _nomeCompletoController = TextEditingController(
      text: militar?.nomeCompleto ?? '',
    );
    _matriculaController = TextEditingController(
      text: militar?.matricula ?? '',
    );
    _pontosController = TextEditingController(
      text: militar?.pontosTotais.toString() ?? '',
    );
    _pesoController = TextEditingController(text: '12');
    _alturaController = TextEditingController(text: '105');
    _larguraController = TextEditingController(text: '15');
    _comprimentoController = TextEditingController(text: '23');
    _descricaoController = TextEditingController();

    _selectedGraduacao = militar?.graduacao;
  }

  @override
  void dispose() {
    _nomeGuerraController.dispose();
    _nomeCompletoController.dispose();
    _matriculaController.dispose();
    _pontosController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _larguraController.dispose();
    _comprimentoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  PolicialMilitarModel _buildMilitarFromForm() {
    return PolicialMilitarModel(
      id: widget.militar?.id ?? DateTime.now().millisecondsSinceEpoch,
      nomeGuerra: _nomeGuerraController.text,
      graduacao: _selectedGraduacao ?? Graduacao.soldado,
      nomeCompleto: _nomeCompletoController.text,
      matricula: _matriculaController.text,
      pontosTotais: double.tryParse(_pontosController.text) ?? 0.0,
      avatarUrl: widget.militar?.avatarUrl ?? 'https://i.pravatar.cc/150',
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final militar = _buildMilitarFromForm();
      widget.onSave?.call(militar);
      Navigator.of(context).pop();
    }
  }

  void _onSchedule() {
    if (_formKey.currentState?.validate() ?? false) {
      final militar = _buildMilitarFromForm();
      widget.onSchedule?.call(militar);
      Navigator.of(context).pop();
    }
  }

  void _onDiscard() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colorTheme.bgNeutralPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context),

            // Form content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Primeira linha: Nome Guerra + Graduação
                      _buildRow(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Nome de Guerra',
                              hint: 'Digite o nome de guerra',
                              controller: _nomeGuerraController,
                              validator: _requiredValidator,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: _buildGraduacaoDropdown(context)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Segunda linha: Nome Completo + Matrícula
                      _buildRow(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Nome Completo',
                              hint: 'Nome completo do militar',
                              controller: _nomeCompletoController,
                              validator: _requiredValidator,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Matrícula',
                              hint: '\$0000000-0',
                              controller: _matriculaController,
                              validator: _requiredValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Terceira linha: Peso, Altura, Largura, Comprimento
                      _buildRow(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Peso (kg)',
                              hint: '0',
                              controller: _pesoController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Altura (cm)',
                              hint: '0',
                              controller: _alturaController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Largura (cm)',
                              hint: '0',
                              controller: _larguraController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              label: 'Comprimento (cm)',
                              hint: '0',
                              controller: _comprimentoController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Descrição
                      _buildTextField(
                        context: context,
                        label: 'Descrição',
                        hint: 'Escreva a descrição do militar aqui',
                        controller: _descricaoController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),

                      // Tipo de Operação (checkboxes)
                      _buildTipoOperacaoSection(context),
                      const SizedBox(height: 16),

                      // Upload de imagens
                      _buildImageUploadSection(context),
                    ],
                  ),
                ),
              ),
            ),

            // Footer com botões
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colorTheme.borderDefault),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isEditing ? 'Editar Militar' : 'Adicionar Militar',
            style: context.customTextTheme.textLgSemibold.copyWith(
              color: context.colorTheme.fgHeading,
            ),
          ),
          IconButton(
            onPressed: _onDiscard,
            icon: Icon(
              Icons.close,
              color: context.colorTheme.fgBodySubtle,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required List<Widget> children}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          style: context.customTextTheme.textSm.copyWith(
            color: context.colorTheme.fgBody,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgBodySubtle,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: context.colorTheme.bgNeutralSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.borderDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: FlowbiteColors.blue600, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.bgDanger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.colorTheme.bgDanger,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraduacaoDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Selecionar Graduação',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
            const SizedBox(width: 4),
            Tooltip(
              message: 'Selecione a graduação do militar',
              child: Icon(
                Icons.info_outline,
                size: 14,
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.colorTheme.bgNeutralSecondary,
            border: Border.all(color: context.colorTheme.borderDefault),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<Graduacao>(
            value: _selectedGraduacao,
            hint: Text(
              'Selecionar graduação',
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
            isExpanded: true,
            icon: Icon(
              Icons.expand_more,
              color: context.colorTheme.fgBodySubtle,
            ),
            style: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgBody,
            ),
            dropdownColor: context.colorTheme.bgNeutralPrimary,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            items: Graduacao.values.map((graduacao) {
              return DropdownMenuItem<Graduacao>(
                value: graduacao,
                child: Text(graduacao.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGraduacao = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Selecione uma graduação';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTipoOperacaoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Operação',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: TipoOperacao.values.map((tipo) {
            final isSelected = _selectedTipoOperacao == tipo;
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: InkWell(
                onTap: () => setState(() => _selectedTipoOperacao = tipo),
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? FlowbiteColors.blue600
                            : context.colorTheme.bgNeutralPrimary,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? FlowbiteColors.blue600
                              : context.colorTheme.borderDefault,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: FlowbiteColors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tipo.displayName,
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.colorTheme.fgBody,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagens do Militar',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: context.colorTheme.bgNeutralSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.colorTheme.borderDefault,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: context.colorTheme.fgBodySubtle,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Clique para enviar',
                      style: context.customTextTheme.textSmSemibold.copyWith(
                        color: FlowbiteColors.blue600,
                      ),
                    ),
                    TextSpan(
                      text: ' ou arraste e solte',
                      style: context.customTextTheme.textSm.copyWith(
                        color: context.colorTheme.fgBodySubtle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SVG, PNG, JPG ou GIF (MÁX. 800×400px)',
                style: context.customTextTheme.textXs.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.colorTheme.borderDefault),
        ),
      ),
      child: Row(
        children: [
          // Botão Adicionar/Salvar
          ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: FlowbiteColors.blue600,
              foregroundColor: FlowbiteColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              _isEditing ? 'Salvar alterações' : 'Adicionar militar',
              style: context.customTextTheme.textSmSemibold.copyWith(
                color: FlowbiteColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Botão Agendar
          ElevatedButton.icon(
            onPressed: _onSchedule,
            icon: Icon(
              Icons.calendar_today,
              size: 16,
              color: FlowbiteColors.white,
            ),
            label: Text(
              'Agendar',
              style: context.customTextTheme.textSmSemibold.copyWith(
                color: FlowbiteColors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlowbiteColors.blue600,
              foregroundColor: FlowbiteColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 12),

          // Botão Descartar
          OutlinedButton(
            onPressed: _onDiscard,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorTheme.fgBody,
              side: BorderSide(color: context.colorTheme.borderDefault),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Descartar',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
