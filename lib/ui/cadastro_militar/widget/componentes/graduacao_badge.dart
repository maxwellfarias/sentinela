import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import '../../../../domain/models/policial_militar/policial_militar_model.dart';

/// Badge de graduação militar
class GraduacaoBadge extends StatelessWidget {
  final Graduacao graduacao;
  final VoidCallback? onTap;

  const GraduacaoBadge({super.key, required this.graduacao, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: graduacao.displayName,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getIcon(), size: 12, color: _getTextColor(context)),
              const SizedBox(width: 4),
              Text(
                graduacao.sigla,
                style: context.customTextTheme.textXsMedium.copyWith(
                  color: _getTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    // Oficiais superiores (Coronel, Ten. Coronel, Major)
    if (graduacao.ordemHierarquica >= 11) {
      return context.colorTheme.bgBrandSoft;
    }
    // Oficiais intermediários (Capitão)
    if (graduacao.ordemHierarquica == 10) {
      return FlowbiteColors.purple100;
    }
    // Oficiais subalternos (Tenentes e Aspirante)
    if (graduacao.ordemHierarquica >= 7) {
      return FlowbiteColors.teal100;
    }
    // Subtenente e Sargentos
    if (graduacao.ordemHierarquica >= 3) {
      return FlowbiteColors.orange100;
    }
    // Cabo e Soldado
    return FlowbiteColors.gray100;
  }

  Color _getTextColor(BuildContext context) {
    // Oficiais superiores
    if (graduacao.ordemHierarquica >= 11) {
      return context.colorTheme.bgBrandStrong;
    }
    // Oficiais intermediários
    if (graduacao.ordemHierarquica == 10) {
      return FlowbiteColors.purple700;
    }
    // Oficiais subalternos
    if (graduacao.ordemHierarquica >= 7) {
      return FlowbiteColors.teal700;
    }
    // Subtenente e Sargentos
    if (graduacao.ordemHierarquica >= 3) {
      return FlowbiteColors.orange700;
    }
    // Cabo e Soldado
    return FlowbiteColors.gray700;
  }

  IconData _getIcon() {
    // Oficiais superiores
    if (graduacao.ordemHierarquica >= 11) {
      return Icons.military_tech;
    }
    // Oficiais intermediários e subalternos
    if (graduacao.ordemHierarquica >= 7) {
      return Icons.star;
    }
    // Subtenente e Sargentos
    if (graduacao.ordemHierarquica >= 3) {
      return Icons.shield;
    }
    // Cabo e Soldado
    return Icons.person;
  }
}
