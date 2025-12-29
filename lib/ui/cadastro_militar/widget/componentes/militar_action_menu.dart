import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import '../../../../domain/models/policial_militar/policial_militar_model.dart';

/// Menu de ações para cada militar na tabela
class MilitarActionMenu extends StatelessWidget {
  final PolicialMilitarModel militar;
  final VoidCallback? onDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MilitarActionMenu({
    super.key,
    required this.militar,
    this.onDetails,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: context.colorTheme.fgBodySubtle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      offset: const Offset(0, 8),
      color: context.colorTheme.bgNeutralPrimary,
      elevation: 4,
      onSelected: (value) {
        switch (value) {
          case 'details':
            onDetails?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 16,
                color: context.colorTheme.fgBody,
              ),
              const SizedBox(width: 8),
              Text(
                'Ver detalhes',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: context.colorTheme.fgBody,
              ),
              const SizedBox(width: 8),
              Text(
                'Editar',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outlined,
                size: 16,
                color: context.colorTheme.fgDanger,
              ),
              const SizedBox(width: 8),
              Text(
                'Excluir',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgDanger,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
