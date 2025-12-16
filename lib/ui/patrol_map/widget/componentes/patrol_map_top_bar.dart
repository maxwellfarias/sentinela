import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Barra superior do mapa de patrulha com menu, busca e notificações
class PatrolMapTopBar extends StatelessWidget {
  final TextEditingController searchController;
  final bool isOnline;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationsPressed;
  final ValueChanged<String>? onSearchChanged;

  const PatrolMapTopBar({
    super.key,
    required this.searchController,
    required this.isOnline,
    this.onMenuPressed,
    this.onNotificationsPressed,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            // Menu Button
            _CircleButton(icon: Icons.menu, onPressed: onMenuPressed),
            const SizedBox(width: 12),
            // Search Bar
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: context.colorTheme.bgNeutralSecondaryStrongest
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: context.colorTheme.borderDarkSubtle,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.search,
                      color: context.colorTheme.fgBodySubtle,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: context.customTextTheme.textSm.copyWith(
                          color: context.colorTheme.fgHeading,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Buscar placa ou local...',
                          hintStyle: context.customTextTheme.textSm.copyWith(
                            color: context.colorTheme.fgBodySubtle,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: onSearchChanged,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: context.colorTheme.borderDarkSubtle,
                    ),
                    const SizedBox(width: 12),
                    // Online Status
                    _OnlineStatus(isOnline: isOnline),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Notifications Button
            _CircleButton(
              icon: Icons.notifications_outlined,
              onPressed: onNotificationsPressed,
              badgeCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de contexto mostrando o setor da patrulha
class PatrolContextChip extends StatelessWidget {
  final String sector;

  const PatrolContextChip({super.key, required this.sector});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colorTheme.bgBrand.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.colorTheme.bgBrand.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorTheme.bgBrand.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_police_outlined,
            size: 16,
            color: context.colorTheme.bgNeutralPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            'PATRULHA - $sector',
            style: context.customTextTheme.textXsBold.copyWith(
              color: context.colorTheme.bgNeutralPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão circular reutilizável
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final int badgeCount;

  const _CircleButton({
    required this.icon,
    this.onPressed,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
              onTap:  onPressed,
              customBorder: const CircleBorder(),
              child: Icon(icon, color: context.colorTheme.fgHeading, size: 24),
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: context.colorTheme.bgDanger,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorTheme.bgNeutralSecondaryStrongest,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Indicador de status online/offline
class _OnlineStatus extends StatelessWidget {
  final bool isOnline;

  const _OnlineStatus({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isOnline
                ? context.colorTheme.fgSuccess
                : context.colorTheme.fgDanger,
            shape: BoxShape.circle,
            boxShadow: isOnline
                ? [
                    BoxShadow(
                      color: context.colorTheme.fgSuccess.withValues(
                        alpha: 0.5,
                      ),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isOnline ? 'ONLINE' : 'OFFLINE',
          style: context.customTextTheme.textXsBold.copyWith(
            color: isOnline
                ? context.colorTheme.fgSuccess
                : context.colorTheme.fgDanger,
          ),
        ),
      ],
    );
  }
}
