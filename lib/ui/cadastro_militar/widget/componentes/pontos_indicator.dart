import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';

/// Indicador de pontos totais do militar
class PontosIndicator extends StatelessWidget {
  final double pontos;
  final double maxPontos;

  const PontosIndicator({
    super.key,
    required this.pontos,
    this.maxPontos = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = pontos >= 4.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: isPositive
              ? context.colorTheme.fgSuccess
              : context.colorTheme.fgDanger,
        ),
        const SizedBox(width: 4),
        Text(
          pontos.toStringAsFixed(1),
          style: context.customTextTheme.textSmMedium.copyWith(
            color: isPositive
                ? context.colorTheme.fgSuccess
                : context.colorTheme.fgDanger,
          ),
        ),
      ],
    );
  }
}
