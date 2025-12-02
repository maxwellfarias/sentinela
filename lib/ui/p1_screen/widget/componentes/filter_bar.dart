import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Barra de filtros da tela de eventos
class FilterBar extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback? onMoreOptions;
  final VoidCallback? onActions;

  const FilterBar({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
    this.onMoreOptions,
    this.onActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      'Current year',
      'Past month',
      'Last 30 days',
      'Last 7 days',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.customColorTheme.card,
        border: Border(
          bottom: BorderSide(color: context.customColorTheme.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort filters
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'Sort',
                    style: context.customTextTheme.textSmSemibold.copyWith(
                      color: context.customColorTheme.foreground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ...filters.map((filter) {
                    final isSelected = currentFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            onFilterChanged(filter);
                          }
                        },
                        backgroundColor: isSelected
                            ? context.customColorTheme.muted
                            : Colors.transparent,
                        selectedColor: context.customColorTheme.muted,
                        labelStyle: context.customTextTheme.textSm.copyWith(
                          color: context.customColorTheme.foreground,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide.none,
                        ),
                      ),
                    );
                  }).toList(),
                  // More options button
                  TextButton.icon(
                    onPressed: onMoreOptions,
                    icon: Icon(
                      Icons.tune,
                      size: 18,
                      color: context.customColorTheme.primary,
                    ),
                    label: Text(
                      'More options',
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Actions dropdown
          OutlinedButton.icon(
            onPressed: onActions,
            icon: Text(
              'Actions',
              style: context.customTextTheme.textSm.copyWith(
                color: context.customColorTheme.foreground,
              ),
            ),
            label: Icon(
              Icons.expand_more,
              size: 18,
              color: context.customColorTheme.foreground,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.customColorTheme.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
