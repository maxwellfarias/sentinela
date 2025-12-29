import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import '../../../../domain/models/policial_militar/policial_militar_model.dart';

/// Barra de filtros para a tabela de militares
class MilitaresFilterBar extends StatelessWidget {
  final String? selectedGraduacao;
  final String? selectedStatus;
  final String selectedShowOnly;
  final ValueChanged<String?>? onGraduacaoChanged;
  final ValueChanged<String?>? onStatusChanged;
  final ValueChanged<String>? onShowOnlyChanged;

  const MilitaresFilterBar({
    super.key,
    this.selectedGraduacao,
    this.selectedStatus,
    this.selectedShowOnly = 'Todos',
    this.onGraduacaoChanged,
    this.onStatusChanged,
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
              hint: 'Graduação',
              value: selectedGraduacao,
              items: Graduacao.values.map((g) => g.displayName).toList(),
              onChanged: onGraduacaoChanged,
            ),
            _buildDropdown(
              context: context,
              hint: 'Status',
              value: selectedStatus,
              items: const ['Ativo', 'Inativo', 'Afastado', 'Férias'],
              onChanged: onStatusChanged,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Linha de radio buttons "Exibir apenas"
        Row(
          children: [
            Text(
              'Exibir apenas:',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
            const SizedBox(width: 16),
            _buildRadioOption(context, 'Todos'),
            _buildRadioOption(context, 'Oficiais'),
            _buildRadioOption(context, 'Praças'),
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
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        border: Border.all(color: context.colorTheme.borderDefault),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
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
