import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'componentes/militar_form_dialog.dart';
import '../../../domain/models/policial_militar/policial_militar_model.dart';
import 'componentes/militares_filter_bar.dart';
import 'componentes/militares_table.dart';

/// Tela de gerenciamento de cadastro de militares
///
/// Exibe uma tabela com lista de militares, filtros e ações de CRUD.
/// Implementada seguindo os padrões do custom_screen.md.
final class CadastroMilitar extends StatefulWidget {
  const CadastroMilitar({super.key});

  @override
  State<CadastroMilitar> createState() => _CadastroMilitarState();
}

class _CadastroMilitarState extends State<CadastroMilitar> {
  // ==================== STATE ====================

  /// IDs dos militares selecionados na tabela
  Set<int> _selectedMilitarIds = {};

  /// Filtros selecionados
  String? _selectedGraduacao;
  String? _selectedStatus;
  String _selectedShowOnly = 'Todos';

  /// Paginação
  int _currentPage = 1;
  int _pageSize = 10;

  /// Lista de militares (dados fictícios)
  List<PolicialMilitarModel> get _filteredMilitares {
    var militares = List<PolicialMilitarModel>.from(mockMilitares);

    // Aplicar filtro "Exibir apenas"
    switch (_selectedShowOnly) {
      case 'Oficiais':
        militares = militares
            .where((m) => m.graduacao.ordemHierarquica >= 7)
            .toList();
        break;
      case 'Praças':
        militares = militares
            .where((m) => m.graduacao.ordemHierarquica < 7)
            .toList();
        break;
    }

    // Aplicar filtros de dropdown
    if (_selectedGraduacao != null) {
      militares = militares
          .where((m) => m.graduacao.displayName == _selectedGraduacao)
          .toList();
    }

    return militares;
  }

  int get _totalRecords => _filteredMilitares.length;
  int get _totalPages => (_totalRecords / _pageSize).ceil().clamp(1, 100);

  List<PolicialMilitarModel> get _paginatedMilitares {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, _totalRecords);
    if (startIndex >= _totalRecords) return [];
    return _filteredMilitares.sublist(startIndex, endIndex);
  }

  // ==================== CALLBACKS ====================

  void _onSelectionChanged(Set<int> selectedIds) {
    setState(() {
      _selectedMilitarIds = selectedIds;
    });
  }

  void _onMilitarDetails(PolicialMilitarModel militar) {
    _showSnackBar('Detalhes de ${militar.nomeGuerra}');
  }

  void _onMilitarEdit(PolicialMilitarModel militar) {
    _onEditMilitar(militar);
  }

  void _onMilitarDelete(PolicialMilitarModel militar) {
    _showSnackBar('Deletando ${militar.nomeGuerra}', isError: true);
  }

  void _onAddNewMilitar() {
    MilitarFormDialog.show(
      context: context,
      onSave: (militar) {
        _showSnackBar('Militar ${militar.nomeGuerra} adicionado com sucesso');
      },
      onSchedule: (militar) {
        _showSnackBar('Agendamento para ${militar.nomeGuerra} criado');
      },
    );
  }

  void _onEditMilitar(PolicialMilitarModel militar) {
    MilitarFormDialog.show(
      context: context,
      militar: militar,
      onSave: (updatedMilitar) {
        _showSnackBar(
          'Militar ${updatedMilitar.nomeGuerra} atualizado com sucesso',
        );
      },
      onSchedule: (updatedMilitar) {
        _showSnackBar('Agendamento para ${updatedMilitar.nomeGuerra} criado');
      },
    );
  }

  void _onSuspendAll() {
    _showSnackBar('Suspender todos selecionados');
  }

  void _onArchiveAll() {
    _showSnackBar('Arquivar todos selecionados');
  }

  void _onDeleteAll() {
    _showSnackBar('Deletar todos selecionados', isError: true);
  }

  void _onTableSettings() {
    _showSnackBar('Configurações da tabela');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onPageSizeChanged(int size) {
    setState(() {
      _pageSize = size;
      _currentPage = 1;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? context.colorTheme.bgDanger
            : context.colorTheme.bgSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.bgNeutralSecondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com estatísticas e botões
            _buildHeader(context),
            const SizedBox(height: 24),

            // Container principal
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colorTheme.bgNeutralPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: FlowbiteColors.gray900.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtros
                  MilitaresFilterBar(
                    selectedGraduacao: _selectedGraduacao,
                    selectedStatus: _selectedStatus,
                    selectedShowOnly: _selectedShowOnly,
                    onGraduacaoChanged: (value) =>
                        setState(() => _selectedGraduacao = value),
                    onStatusChanged: (value) =>
                        setState(() => _selectedStatus = value),
                    onShowOnlyChanged: (value) =>
                        setState(() => _selectedShowOnly = value),
                  ),
                  const SizedBox(height: 24),

                  // Tabela de militares
                  MilitaresTable(
                    militares: _paginatedMilitares,
                    selectedMilitarIds: _selectedMilitarIds,
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    pageSize: _pageSize,
                    totalRecords: _totalRecords,
                    onSelectionChanged: _onSelectionChanged,
                    onMilitarDetails: _onMilitarDetails,
                    onMilitarEdit: _onMilitarEdit,
                    onMilitarDelete: _onMilitarDelete,
                    onPageChanged: _onPageChanged,
                    onPageSizeChanged: _onPageSizeChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Estatísticas e título
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estatísticas
            Row(
              children: [
                Text(
                  'Total Militares: ',
                  style: context.customTextTheme.textSmMedium.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
                Text(
                  '${mockMilitares.length}',
                  style: context.customTextTheme.textSmBold.copyWith(
                    color: context.colorTheme.fgHeading,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Projetos: ',
                  style: context.customTextTheme.textSmMedium.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
                Text(
                  '884',
                  style: context.customTextTheme.textSmBold.copyWith(
                    color: context.colorTheme.fgHeading,
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Informações sobre os projetos',
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Botão Add new militar
            ElevatedButton.icon(
              onPressed: _onAddNewMilitar,
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'Adicionar militar',
                style: context.customTextTheme.textSmSemibold.copyWith(
                  color: FlowbiteColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlowbiteColors.blue600,
                foregroundColor: FlowbiteColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
        // Ações em lote e configurações
        Row(
          children: [
            // Botão Suspender todos
            OutlinedButton(
              onPressed: _onSuspendAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorTheme.fgBody,
                side: BorderSide(color: context.colorTheme.borderDefault),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Suspender todos',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Botão Arquivar todos
            OutlinedButton(
              onPressed: _onArchiveAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorTheme.fgBody,
                side: BorderSide(color: context.colorTheme.borderDefault),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Arquivar todos',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Botão Deletar todos
            OutlinedButton(
              onPressed: _onDeleteAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorTheme.fgDanger,
                side: BorderSide(color: context.colorTheme.borderDefault),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Deletar todos',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgDanger,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Botão de configurações
            OutlinedButton.icon(
              onPressed: _onTableSettings,
              icon: Icon(
                Icons.settings_outlined,
                size: 16,
                color: context.colorTheme.fgBody,
              ),
              label: Text(
                'Configurações da tabela',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorTheme.fgBody,
                side: BorderSide(color: context.colorTheme.borderDefault),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
