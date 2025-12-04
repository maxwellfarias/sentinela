import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'user_model_mock.dart';

/// Badge de role do usuário (Administrator, Moderator, Viewer)
class UserRoleBadge extends StatelessWidget {
  final UserRole role;
  final VoidCallback? onTap;

  const UserRoleBadge({super.key, required this.role, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: role.description,
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
                role.displayName,
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
    switch (role) {
      case UserRole.administrator:
        return context.colorTheme.bgBrandSoft;
      case UserRole.moderator:
        return FlowbiteColors.purple100;
      case UserRole.viewer:
        return FlowbiteColors.gray100;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (role) {
      case UserRole.administrator:
        return context.colorTheme.bgBrandStrong;
      case UserRole.moderator:
        return FlowbiteColors.purple700;
      case UserRole.viewer:
        return FlowbiteColors.gray700;
    }
  }

  IconData _getIcon() {
    switch (role) {
      case UserRole.administrator:
        return Icons.shield;
      case UserRole.moderator:
        return Icons.verified_user_outlined;
      case UserRole.viewer:
        return Icons.visibility_outlined;
    }
  }
}
