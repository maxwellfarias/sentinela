import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/kabam/widget/componentes/kabam_models.dart';

/// Card de tarefa individual no quadro Kanban
class KabamTaskCard extends StatelessWidget {
  final KabamTask task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const KabamTaskCard({super.key, required this.task, this.onTap, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorTheme.borderDefault, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colorTheme.bgDark.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título e ícone de edição
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: context.customTextTheme.textSmSemibold.copyWith(
                          color: context.colorTheme.fgHeading,
                        ),
                      ),
                    ),
                    if (onEdit != null)
                      InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: context.colorTheme.fgBodySubtle,
                          ),
                        ),
                      ),
                  ],
                ),

                // Imagem do gráfico (se houver)
                if (task.hasChart) ...[
                  const SizedBox(height: 12),
                  _buildChartPlaceholder(context),
                ],

                // Descrição
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: context.customTextTheme.textXs.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Footer: avatares e badge de status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Avatares dos membros
                    _buildAvatarStack(context),

                    // Badge de status/prazo
                    if (task.badge != null) _buildBadge(context, task.badge!),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Simulação de gráfico de barras
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Lado esquerdo - mini chart
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics',
                        style: context.customTextTheme.textXs.copyWith(
                          color: context.colorTheme.fgBodySubtle,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '163.4k',
                            style: context.customTextTheme.textXsSemibold
                                .copyWith(color: context.colorTheme.fgHeading),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '163.4k',
                            style: context.customTextTheme.textXsSemibold
                                .copyWith(color: context.colorTheme.fgHeading),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Mini barras horizontais
                      _buildMiniBar(context, 0.8, context.colorTheme.bgBrand),
                      const SizedBox(height: 4),
                      _buildMiniBar(context, 0.5, context.colorTheme.bgSuccess),
                    ],
                  ),
                ),
                // Lado direito - gráfico de barras verticais
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildVerticalBar(
                        context,
                        0.4,
                        context.colorTheme.bgBrandSoft,
                      ),
                      _buildVerticalBar(
                        context,
                        0.7,
                        context.colorTheme.bgBrand,
                      ),
                      _buildVerticalBar(
                        context,
                        0.5,
                        context.colorTheme.bgBrandSoft,
                      ),
                      _buildVerticalBar(
                        context,
                        0.6,
                        context.colorTheme.bgBrand,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Círculo de porcentagem
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorTheme.bgBrandSoft,
                border: Border.all(color: context.colorTheme.bgBrand, width: 3),
              ),
              child: Center(
                child: Text(
                  '\$65.4k',
                  style: context.customTextTheme.textXsSemibold.copyWith(
                    color: context.colorTheme.fgBrand,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBar(BuildContext context, double width, Color color) {
    return Container(
      height: 6,
      width: 60 * width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildVerticalBar(BuildContext context, double height, Color color) {
    return Container(
      width: 16,
      height: 50 * height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    final avatarColors = [
      context.colorTheme.bgBrand,
      context.colorTheme.bgSuccess,
      context.colorTheme.bgWarning,
    ];

    return SizedBox(
      height: 28,
      width: 68,
      child: Stack(
        children: List.generate(
          task.memberCount.clamp(0, 3),
          (index) => Positioned(
            left: index * 18.0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColors[index % avatarColors.length],
                border: Border.all(
                  color: context.colorTheme.bgNeutralPrimary,
                  width: 2,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://i.pravatar.cc/56?img=${index + task.title.hashCode % 70}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, TaskBadge badge) {
    Color bgColor;
    Color fgColor;
    IconData icon;

    switch (badge.type) {
      case BadgeType.tomorrow:
        bgColor = context.colorTheme.bgDangerSoft;
        fgColor = context.colorTheme.fgDanger;
        icon = Icons.calendar_today;
        break;
      case BadgeType.daysLeft:
        bgColor = context.colorTheme.bgWarningSoft;
        fgColor = context.colorTheme.fgWarning;
        icon = Icons.calendar_today;
        break;
      case BadgeType.done:
        bgColor = context.colorTheme.bgSuccessSoft;
        fgColor = context.colorTheme.fgSuccess;
        icon = Icons.check;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 4),
          Text(
            badge.label,
            style: context.customTextTheme.textXsSemibold.copyWith(
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
