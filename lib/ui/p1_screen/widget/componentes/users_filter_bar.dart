import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';

/// Barra de filtros para a tabela de usuários
class UsersFilterBar extends StatelessWidget {
  final String? selectedUserRole;
  final String? selectedStatus;
  final String? selectedAccountType;
  final String? selectedRating;
  final String? selectedCountry;
  final String selectedShowOnly;
  final ValueChanged<String?>? onUserRoleChanged;
  final ValueChanged<String?>? onStatusChanged;
  final ValueChanged<String?>? onAccountTypeChanged;
  final ValueChanged<String?>? onRatingChanged;
  final ValueChanged<String?>? onCountryChanged;
  final ValueChanged<String>? onShowOnlyChanged;

  const UsersFilterBar({
    super.key,
    this.selectedUserRole,
    this.selectedStatus,
    this.selectedAccountType,
    this.selectedRating,
    this.selectedCountry,
    this.selectedShowOnly = 'All',
    this.onUserRoleChanged,
    this.onStatusChanged,
    this.onAccountTypeChanged,
    this.onRatingChanged,
    this.onCountryChanged,
    this.onShowOnlyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Linha de dropdowns
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildDropdown(
              context: context,
              hint: 'User Role',
              value: selectedUserRole,
              items: const ['Administrator', 'Moderator', 'Viewer'],
              onChanged: onUserRoleChanged,
            ),
            _buildDropdown(
              context: context,
              hint: 'Status',
              value: selectedStatus,
              items: const ['Active', 'Inactive'],
              onChanged: onStatusChanged,
            ),
            _buildDropdown(
              context: context,
              hint: 'Account type',
              value: selectedAccountType,
              items: const ['PRO', 'Basic'],
              onChanged: onAccountTypeChanged,
            ),
            _buildDropdown(
              context: context,
              hint: 'Rating',
              value: selectedRating,
              items: const ['5.0', '4.5+', '4.0+', '3.5+', '3.0+'],
              onChanged: onRatingChanged,
            ),
            _buildDropdown(
              context: context,
              hint: 'Country',
              value: selectedCountry,
              items: const [
                'United States',
                'Canada',
                'France',
                'Germany',
                'England',
                'Australia',
              ],
              onChanged: onCountryChanged,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Linha de radio buttons "Show only"
        Row(
          children: [
            Text(
              'Show only:',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
            const SizedBox(width: 16),
            _buildRadioOption(context, 'All'),
            _buildRadioOption(context, 'PRO Accounts'),
            _buildRadioOption(context, 'Admin'),
            _buildRadioOption(context, 'Moderators'),
            _buildRadioOption(context, 'Viewer'),
            const Spacer(),
            // Actions dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: context.colorTheme.borderDefault),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.expand_more,
                    size: 16,
                    color: context.colorTheme.fgBody,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Actions',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.colorTheme.fgBody,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        border: Border.all(color: context.colorTheme.borderDefault),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgBodySubtle,
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: context.colorTheme.fgBodySubtle),
          style: context.customTextTheme.textSm.copyWith(
            color: context.colorTheme.fgBody,
          ),
          dropdownColor: context.colorTheme.bgNeutralPrimary,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, String label) {
    final isSelected = selectedShowOnly == label;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () => onShowOnlyChanged?.call(label),
        borderRadius: BorderRadius.circular(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? FlowbiteColors.blue600
                      : context.colorTheme.borderDefault,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: FlowbiteColors.blue600,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
