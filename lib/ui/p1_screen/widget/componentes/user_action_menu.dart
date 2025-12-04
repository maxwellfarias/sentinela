import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'user_model_mock.dart';

/// Menu de ações do usuário (Details, Edit, Delete)
class UserActionMenu extends StatelessWidget {
  final UserMock user;
  final VoidCallback? onDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserActionMenu({
    super.key,
    required this.user,
    this.onDetails,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: context.colorTheme.fgBodySubtle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                'Details',
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
                'Edit',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                size: 16,
                color: FlowbiteColors.red500,
              ),
              const SizedBox(width: 8),
              Text(
                'Delete',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: FlowbiteColors.red500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
