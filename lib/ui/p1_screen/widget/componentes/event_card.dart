import 'package:flutter/material.dart';
import 'package:sentinela/domain/models/evento/event_model.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:intl/intl.dart';

/// Card individual de evento para exibição na lista
class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isSelected;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onPreview;
  final VoidCallback? onDelete;

  const EventCard({
    Key? key,
    required this.event,
    this.isSelected = false,
    this.onCheckboxChanged,
    this.onEdit,
    this.onPreview,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? context.customColorTheme.muted
            : context.customColorTheme.card,
        border: Border(
          bottom: BorderSide(color: context.customColorTheme.border, width: 1),
        ),
      ),
      child: InkWell(
        onTap: () {},
        hoverColor: context.customColorTheme.muted,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: onCheckboxChanged,
                activeColor: context.customColorTheme.primary,
              ),
              const SizedBox(width: 8),

              // Nome do evento
              Expanded(
                flex: 2,
                child: Text(
                  event.name,
                  style: context.customTextTheme.textSmMedium.copyWith(
                    color: context.customColorTheme.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),

              // Speakers
              Expanded(flex: 2, child: _buildSpeakers()),
              const SizedBox(width: 16),

              // Remaining seats com barra de progresso
              Expanded(flex: 2, child: _buildRemainingSeats(context)),
              const SizedBox(width: 16),

              // Google Meet Link
              Expanded(
                flex: 2,
                child: event.googleMeetLink != null
                    ? Text(
                        event.googleMeetLink!.length > 30
                            ? '${event.googleMeetLink!.substring(0, 30)}...'
                            : event.googleMeetLink!,
                        style: context.customTextTheme.textSm.copyWith(
                          color: context.customColorTheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        'None',
                        style: context.customTextTheme.textSm.copyWith(
                          color: context.customColorTheme.mutedForeground,
                        ),
                      ),
              ),
              const SizedBox(width: 16),

              // Date
              Expanded(flex: 2, child: _buildDateBadge(context)),
              const SizedBox(width: 16),

              // Duration
              Expanded(
                flex: 1,
                child: Text(
                  event.duration,
                  style: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Actions menu
              _buildActionsMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakers() {
    return Row(
      children: [
        // Avatares sobrepostos
        SizedBox(
          width: event.speakerAvatars.length > 2 ? 80 : 60,
          height: 32,
          child: Stack(
            children: [
              ...event.speakerAvatars.take(2).map((avatar) {
                final index = event.speakerAvatars.indexOf(avatar);
                return Positioned(
                  left: index * 20.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(avatar),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                );
              }).toList(),

              // Badge de contagem adicional
              if (event.speakerCount > 2)
                Positioned(
                  left: 40,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[700],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '+${event.speakerCount - 2}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemainingSeats(BuildContext context) {
    final occupiedSeats = event.totalSeats - event.remainingSeats;
    final percentage = event.occupancyPercentage;

    Color progressColor;
    if (percentage >= 80) {
      progressColor = context.customColorTheme.success;
    } else if (percentage >= 50) {
      progressColor = const Color(0xFFFBBF24); // Yellow
    } else {
      progressColor = context.customColorTheme.destructive;
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: context.customColorTheme.muted,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$occupiedSeats/${event.totalSeats}',
          style: context.customTextTheme.textXs.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(event.date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.customColorTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 14,
            color: context.customColorTheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            formattedDate,
            style: context.customTextTheme.textXs.copyWith(
              color: context.customColorTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        color: context.customColorTheme.mutedForeground,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'preview':
            onPreview?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                size: 16,
                color: context.customColorTheme.foreground,
              ),
              const SizedBox(width: 12),
              Text(
                'Edit',
                style: context.customTextTheme.textSm.copyWith(
                  color: context.customColorTheme.foreground,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'preview',
          child: Row(
            children: [
              Icon(
                Icons.visibility,
                size: 16,
                color: context.customColorTheme.foreground,
              ),
              const SizedBox(width: 12),
              Text(
                'Preview',
                style: context.customTextTheme.textSm.copyWith(
                  color: context.customColorTheme.foreground,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                size: 16,
                color: context.customColorTheme.destructive,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: context.customTextTheme.textSm.copyWith(
                  color: context.customColorTheme.destructive,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
