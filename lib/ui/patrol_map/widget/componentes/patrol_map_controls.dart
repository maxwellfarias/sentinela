import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Controles do mapa (camadas, localização)
class PatrolMapControls extends StatelessWidget {
  final VoidCallback? onLayersPressed;
  final VoidCallback? onMyLocationPressed;

  const PatrolMapControls({
    super.key,
    this.onLayersPressed,
    this.onMyLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MapControlButton(
          icon: Icons.layers_outlined,
          onPressed: onLayersPressed,
        ),
        const SizedBox(height: 12),
        _MapControlButton(
          icon: Icons.my_location,
          onPressed: onMyLocationPressed,
        ),
      ],
    );
  }
}

/// Botão de controle do mapa
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _MapControlButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralSecondaryStrongest,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colorTheme.borderDarkSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(icon, color: context.colorTheme.fgHeading, size: 24),
        ),
      ),
    );
  }
}
