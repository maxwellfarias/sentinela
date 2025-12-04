import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'user_model_mock.dart';

/// Badge de status do usuário (Active/Inactive)
class UserStatusBadge extends StatelessWidget {
  final UserStatus status;

  const UserStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == UserStatus.active;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? FlowbiteColors.green500 : FlowbiteColors.red500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status.displayName,
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgBody,
          ),
        ),
      ],
    );
  }
}
