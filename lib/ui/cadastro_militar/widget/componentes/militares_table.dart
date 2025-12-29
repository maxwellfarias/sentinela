import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import '../../../../domain/models/policial_militar/policial_militar_model.dart';
import 'graduacao_badge.dart';
import 'pontos_indicator.dart';
import 'militar_action_menu.dart';

/// Tabela de militares com checkbox, avatar, graduação, etc.
class MilitaresTable extends StatefulWidget {
  final List<PolicialMilitarModel> militares;
  final Set<int> selectedMilitarIds;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalRecords;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final ValueChanged<PolicialMilitarModel>? onMilitarDetails;
  final ValueChanged<PolicialMilitarModel>? onMilitarEdit;
  final ValueChanged<PolicialMilitarModel>? onMilitarDelete;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onPageSizeChanged;

  const MilitaresTable({
    super.key,
    required this.militares,
    this.selectedMilitarIds = const {},
    this.currentPage = 1,
    this.totalPages = 1,
    this.pageSize = 10,
    this.totalRecords = 0,
    this.onSelectionChanged,
    this.onMilitarDetails,
    this.onMilitarEdit,
    this.onMilitarDelete,
    this.onPageChanged,
    this.onPageSizeChanged,
  });

  @override
  State<MilitaresTable> createState() => _MilitaresTableState();
}

class _MilitaresTableState extends State<MilitaresTable> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.selectedMilitarIds);
  }

  @override
  void didUpdateWidget(MilitaresTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMilitarIds != widget.selectedMilitarIds) {
      _selectedIds = Set.from(widget.selectedMilitarIds);
    }
  }

  void _toggleSelection(int militarId) {
    setState(() {
      if (_selectedIds.contains(militarId)) {
        _selectedIds.remove(militarId);
      } else {
        _selectedIds.add(militarId);
      }
    });
    widget.onSelectionChanged?.call(_selectedIds);
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIds.length == widget.militares.length) {
        _selectedIds.clear();
      } else {
        _selectedIds = widget.militares.map((m) => m.id).toSet();
      }
    });
    widget.onSelectionChanged?.call(_selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final allSelected =
        _selectedIds.length == widget.militares.length &&
        widget.militares.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorTheme.borderDefault),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colorTheme.bgNeutralSecondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                _buildHeaderCheckbox(context, allSelected),
                _buildHeaderCell(context, 'NOME DE GUERRA', flex: 2),
                _buildHeaderCell(context, 'GRADUAÇÃO', flex: 2, sortable: true),
                _buildHeaderCell(context, 'NOME COMPLETO', flex: 3),
                _buildHeaderCell(context, 'MATRÍCULA', flex: 2),
                _buildHeaderCell(
                  context,
                  'PONTOS TOTAIS',
                  flex: 2,
                  sortable: true,
                ),
                _buildHeaderCell(context, 'AÇÕES', flex: 1),
              ],
            ),
          ),
          // Rows
          ...widget.militares.map(
            (militar) => _buildMilitarRow(context, militar),
          ),
          // Pagination
          _buildPagination(context),
        ],
      ),
    );
  }

  Widget _buildHeaderCheckbox(BuildContext context, bool allSelected) {
    return SizedBox(
      width: 40,
      child: Checkbox(
        value: allSelected,
        onChanged: (_) => _toggleSelectAll(),
        activeColor: FlowbiteColors.blue600,
        side: BorderSide(color: context.colorTheme.borderDefault),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String label, {
    int flex = 1,
    bool sortable = false,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Text(
            label,
            style: context.customTextTheme.textXsSemibold.copyWith(
              color: context.colorTheme.fgBodySubtle,
              letterSpacing: 0.5,
            ),
          ),
          if (sortable) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.unfold_more,
              size: 14,
              color: context.colorTheme.fgBodySubtle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMilitarRow(BuildContext context, PolicialMilitarModel militar) {
    final isSelected = _selectedIds.contains(militar.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? FlowbiteColors.blue50
            : context.colorTheme.bgNeutralPrimary,
        border: Border(
          bottom: BorderSide(color: context.colorTheme.borderDefault),
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleSelection(militar.id),
              activeColor: FlowbiteColors.blue600,
              side: BorderSide(color: context.colorTheme.borderDefault),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Nome de Guerra (Avatar + Nome)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(militar.avatarUrl),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.person, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    militar.nomeGuerra,
                    style: context.customTextTheme.textSmSemibold.copyWith(
                      color: context.colorTheme.fgHeading,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Graduação
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GraduacaoBadge(graduacao: militar.graduacao),
            ),
          ),
          // Nome Completo
          Expanded(
            flex: 3,
            child: Text(
              militar.nomeCompleto,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBody,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Matrícula
          Expanded(
            flex: 2,
            child: Text(
              militar.matricula,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBody,
              ),
            ),
          ),
          // Pontos Totais
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: PontosIndicator(pontos: militar.pontosTotais),
            ),
          ),
          // Ações
          Expanded(
            flex: 1,
            child: MilitarActionMenu(
              militar: militar,
              onDetails: () => widget.onMilitarDetails?.call(militar),
              onEdit: () => widget.onMilitarEdit?.call(militar),
              onDelete: () => widget.onMilitarDelete?.call(militar),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    final startRecord = (widget.currentPage - 1) * widget.pageSize + 1;
    final endRecord = (startRecord + widget.pageSize - 1).clamp(
      1,
      widget.totalRecords,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rows per page
          Row(
            children: [
              Text(
                'Linhas por página',
                style: context.customTextTheme.textSm.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorTheme.borderDefault),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: widget.pageSize,
                  underline: const SizedBox(),
                  isDense: true,
                  style: context.customTextTheme.textSm.copyWith(
                    color: context.colorTheme.fgBody,
                  ),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5')),
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 25, child: Text('25')),
                    DropdownMenuItem(value: 50, child: Text('50')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      widget.onPageSizeChanged?.call(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$startRecord-$endRecord de ${widget.totalRecords}',
                style: context.customTextTheme.textSm.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                ),
              ),
            ],
          ),
          // Page navigation
          Row(
            children: [
              // Previous button
              IconButton(
                onPressed: widget.currentPage > 1
                    ? () => widget.onPageChanged?.call(widget.currentPage - 1)
                    : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: widget.currentPage > 1
                      ? context.colorTheme.fgBody
                      : context.colorTheme.fgDisabled,
                ),
                splashRadius: 20,
              ),
              // Page numbers
              ..._buildPageNumbers(context),
              // Next button
              IconButton(
                onPressed: widget.currentPage < widget.totalPages
                    ? () => widget.onPageChanged?.call(widget.currentPage + 1)
                    : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: widget.currentPage < widget.totalPages
                      ? context.colorTheme.fgBody
                      : context.colorTheme.fgDisabled,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    final List<Widget> pages = [];
    final int totalPages = widget.totalPages;
    final int currentPage = widget.currentPage;

    // Always show first page
    pages.add(_buildPageButton(context, 1));

    if (totalPages <= 7) {
      // Show all pages if total is 7 or less
      for (int i = 2; i <= totalPages; i++) {
        pages.add(_buildPageButton(context, i));
      }
    } else {
      // Show ellipsis logic for many pages
      if (currentPage > 3) {
        pages.add(_buildEllipsis(context));
      }

      // Show pages around current
      int start = (currentPage - 1).clamp(2, totalPages - 3);
      int end = (currentPage + 1).clamp(4, totalPages - 1);

      for (int i = start; i <= end; i++) {
        pages.add(_buildPageButton(context, i));
      }

      if (currentPage < totalPages - 2) {
        pages.add(_buildEllipsis(context));
      }

      // Always show last page
      pages.add(_buildPageButton(context, totalPages));
    }

    return pages;
  }

  Widget _buildPageButton(BuildContext context, int page) {
    final isSelected = page == widget.currentPage;

    return InkWell(
      onTap: () => widget.onPageChanged?.call(page),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? FlowbiteColors.blue600
              : context.colorTheme.bgNeutralPrimary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? FlowbiteColors.blue600
                : context.colorTheme.borderDefault,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$page',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: isSelected
                ? FlowbiteColors.white
                : context.colorTheme.fgBody,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      child: Text(
        '...',
        style: context.customTextTheme.textSmMedium.copyWith(
          color: context.colorTheme.fgBodySubtle,
        ),
      ),
    );
  }
}
