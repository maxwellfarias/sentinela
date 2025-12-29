import 'package:flutter/material.dart';
import 'package:sentinela/domain/models/veiculo/vehicle_alert_model.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/patrol_map/widget/componentes/vehicle_alert_card.dart';

/// Bottom sheet com informações do alerta selecionado
class PatrolAlertBottomSheet extends StatelessWidget {
  final VehicleAlertModel? alert;
  final VoidCallback? onInterceptPressed;
  final VoidCallback? onCardTap;

  const PatrolAlertBottomSheet({
    super.key,
    this.alert,
    this.onInterceptPressed,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralSecondaryStrongest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: context.colorTheme.borderDarkSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decoração de gradiente no topo
          Container(
            height: 128,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colorTheme.bgBrand.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Handle
          _DragHandle(),
          const SizedBox(height: 8),
          // Conteúdo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _AlertHeader(alert: alert),
                const SizedBox(height: 16),
                // Card do veículo
                if (alert != null)
                  VehicleAlertCard(alert: alert!, onTap: onCardTap),
                const SizedBox(height: 24),
                // Botão de interceptar
                _InterceptButton(onPressed: onInterceptPressed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Handle de arrastar do bottom sheet
class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 6,
        margin: const EdgeInsets.only(top: 12, bottom: 4),
        decoration: BoxDecoration(
          color: context.colorTheme.bgGray,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

/// Cabeçalho do alerta
class _AlertHeader extends StatelessWidget {
  final VehicleAlertModel? alert;

  const _AlertHeader({this.alert});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alerta Próximo',
              style: context.customTextTheme.text2xlBold.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              alert != null
                  ? 'Detectado pelas câmeras ${alert!.tempoDesdeDeteccao}'
                  : 'Nenhum alerta ativo',
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
          ],
        ),
        if (alert != null) _AlertTypeBadge(type: alert!.tipo),
      ],
    );
  }
}

/// Badge do tipo de alerta
class _AlertTypeBadge extends StatelessWidget {
  final VehicleAlertType type;

  const _AlertTypeBadge({required this.type});

  Color _getBadgeColor(BuildContext context) {
    switch (type) {
      case VehicleAlertType.roubado:
      case VehicleAlertType.furtado:
        return context.colorTheme.bgDanger;
      case VehicleAlertType.procurado:
        return context.colorTheme.bgWarning;
      case VehicleAlertType.irregular:
      case VehicleAlertType.suspeito:
        return context.colorTheme.bgBrand;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case VehicleAlertType.roubado:
      case VehicleAlertType.furtado:
        return context.colorTheme.fgDanger;
      case VehicleAlertType.procurado:
        return context.colorTheme.fgWarning;
      case VehicleAlertType.irregular:
      case VehicleAlertType.suspeito:
        return context.colorTheme.fgBrand;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBadgeColor(context).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBadgeColor(context).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        type.label.toUpperCase(),
        style: context.customTextTheme.textXsBold.copyWith(
          color: _getTextColor(context),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Botão de interceptar
class _InterceptButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _InterceptButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorTheme.bgBrand,
          foregroundColor: context.colorTheme.bgNeutralPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: context.colorTheme.bgBrand.withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.near_me,
              size: 20,
              color: context.colorTheme.bgNeutralPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              'Interceptar Agora',
              style: context.customTextTheme.textBaseBold.copyWith(
                color: context.colorTheme.bgNeutralPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
