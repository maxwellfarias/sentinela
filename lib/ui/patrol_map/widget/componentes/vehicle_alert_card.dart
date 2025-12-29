import 'package:flutter/material.dart';
import 'package:sentinela/domain/models/veiculo/vehicle_alert_model.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Card de exibição de veículo em alerta
class VehicleAlertCard extends StatelessWidget {
  final VehicleAlertModel alert;
  final VoidCallback? onTap;

  const VehicleAlertCard({super.key, required this.alert, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorTheme.bgNeutralTertiaryMedium,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorTheme.borderDarkSubtle,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Imagem do veículo
                _VehicleImage(imageUrl: alert.imagemUrl),
                const SizedBox(width: 16),
                // Detalhes do veículo
                Expanded(child: _VehicleDetails(alert: alert)),
                // Seta de navegação
                Icon(
                  Icons.chevron_right,
                  color: context.colorTheme.fgBodySubtle,
                  size: 24,
                ),
              ],
            ),
            // Barra de progresso simulada
            const SizedBox(height: 12),
            _ProgressBar(progress: 0.75),
          ],
        ),
      ),
    );
  }
}

/// Imagem do veículo com placeholder
class _VehicleImage extends StatelessWidget {
  final String? imageUrl;

  const _VehicleImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralSecondaryStrongest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.colorTheme.borderDarkSubtle,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _PlaceholderIcon();
                },
              )
            : _PlaceholderIcon(),
      ),
    );
  }
}

/// Ícone placeholder para quando não há imagem
class _PlaceholderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colorTheme.bgNeutralSecondaryStrongest,
            context.colorTheme.bgNeutralSecondaryStrongest.withValues(
              alpha: 0.6,
            ),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.directions_car,
          size: 40,
          color: context.colorTheme.fgBodySubtle,
        ),
      ),
    );
  }
}

/// Detalhes do veículo
class _VehicleDetails extends StatelessWidget {
  final VehicleAlertModel alert;

  const _VehicleDetails({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome do veículo
        Text(
          alert.nomeCompleto,
          style: context.customTextTheme.textLgBold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Placa e cor
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.colorTheme.bgNeutralSecondaryStrongest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: context.colorTheme.borderDarkSubtle,
                  width: 1,
                ),
              ),
              child: Text(
                alert.placa,
                style: context.customTextTheme.textXsMedium.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '•',
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              alert.cor,
              style: context.customTextTheme.textXs.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Distância e hora
        Row(
          children: [
            Icon(
              Icons.straighten,
              size: 16,
              color: context.colorTheme.fgBodySubtle,
            ),
            const SizedBox(width: 4),
            Text(
              alert.distanciaFormatada,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.schedule,
              size: 16,
              color: context.colorTheme.fgBodySubtle,
            ),
            const SizedBox(width: 4),
            Text(
              alert.horaFormatada,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Barra de progresso
class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralSecondaryStrongest,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: context.colorTheme.bgDanger,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
