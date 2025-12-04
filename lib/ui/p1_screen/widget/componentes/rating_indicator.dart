import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';

/// Indicador de rating com seta de tendência
class RatingIndicator extends StatelessWidget {
  final double rating;

  const RatingIndicator({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final isPositive = rating >= 4.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: isPositive ? FlowbiteColors.green500 : FlowbiteColors.red500,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgBody,
          ),
        ),
      ],
    );
  }
}
