import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Item de breadcrumb
class BreadcrumbItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const BreadcrumbItem({required this.label, this.icon, this.onTap});
}

/// Componente de breadcrumb de navegação
class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _buildItem(context, items[i], isLast: i == items.length - 1),
          if (i < items.length - 1) _buildSeparator(context),
        ],
      ],
    );
  }

  Widget _buildItem(
    BuildContext context,
    BreadcrumbItem item, {
    bool isLast = false,
  }) {
    final color = isLast
        ? context.colorTheme.fgBodySubtle
        : context.colorTheme.fgBody;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, size: 16, color: color),
              const SizedBox(width: 6),
            ],
            Text(
              item.label,
              style: context.customTextTheme.textSmMedium.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.chevron_right,
        size: 16,
        color: context.colorTheme.fgBodySubtle,
      ),
    );
  }
}
