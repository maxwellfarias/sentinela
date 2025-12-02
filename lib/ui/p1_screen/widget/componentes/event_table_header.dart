import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Header da tabela de eventos com colunas e ordenação
class EventTableHeader extends StatelessWidget {
  final bool allSelected;
  final ValueChanged<bool?>? onSelectAll;
  final ValueChanged<String>? onSort;

  const EventTableHeader({
    Key? key,
    required this.allSelected,
    this.onSelectAll,
    this.onSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.customColorTheme.muted,
        border: Border(
          bottom: BorderSide(color: context.customColorTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Checkbox para selecionar todos
          Checkbox(
            value: allSelected,
            onChanged: onSelectAll,
            activeColor: context.customColorTheme.primary,
          ),
          const SizedBox(width: 8),

          // EVENT
          Expanded(
            flex: 2,
            child: _buildHeaderCell(
              context,
              'EVENT',
              sortable: true,
              onSort: () => onSort?.call('event'),
            ),
          ),
          const SizedBox(width: 16),

          // SPEAKERS
          Expanded(
            flex: 2,
            child: _buildHeaderCell(
              context,
              'SPEAKERS',
              sortable: true,
              onSort: () => onSort?.call('speakers'),
            ),
          ),
          const SizedBox(width: 16),

          // REMAINING SEATS
          Expanded(
            flex: 2,
            child: _buildHeaderCell(
              context,
              'REMAINING SEATS',
              sortable: true,
              onSort: () => onSort?.call('seats'),
            ),
          ),
          const SizedBox(width: 16),

          // GOOGLE MEET
          Expanded(
            flex: 2,
            child: _buildHeaderCell(context, 'GOOGLE MEET', sortable: false),
          ),
          const SizedBox(width: 16),

          // DATE
          Expanded(
            flex: 2,
            child: _buildHeaderCell(
              context,
              'DATE',
              sortable: true,
              onSort: () => onSort?.call('date'),
            ),
          ),
          const SizedBox(width: 16),

          // DURATION
          Expanded(
            flex: 1,
            child: _buildHeaderCell(
              context,
              'DURATION',
              sortable: true,
              onSort: () => onSort?.call('duration'),
            ),
          ),
          const SizedBox(width: 16),

          // Actions (empty header)
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String label, {
    bool sortable = false,
    VoidCallback? onSort,
  }) {
    return InkWell(
      onTap: sortable ? onSort : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.customTextTheme.textXs.copyWith(
              color: context.customColorTheme.mutedForeground,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          if (sortable) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.unfold_more,
              size: 16,
              color: context.customColorTheme.mutedForeground,
            ),
          ],
        ],
      ),
    );
  }
}
