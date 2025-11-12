import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';

final class CustomDatePicker extends StatefulWidget {
  final String label;
  final DateTime? value;
  final void Function(DateTime) onDateSelected;
  final bool isRequired;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onDateSelected,
    this.isRequired = false,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: context.customColorTheme.primary,
                  onPrimary: context.customColorTheme.primaryForeground,
                  surface: context.customColorTheme.card,
                  onSurface: context.customColorTheme.cardForeground,
                ),
              ),
              child: child!,
            );
          },
        );

        if (date != null) {
          widget.onDateSelected(date);
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: TextFormField(
        enabled: false,
        validator: (value) =>
            widget.isRequired && (value == null || value.isEmpty)
            ? 'Este campo é obrigatório'
            : null,
        decoration: InputDecoration(
          hintText: 'Selecione a data',
          hintStyle: context.customTextTheme.textSm.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
          suffixIcon: Icon(
            Icons.calendar_today,
            size: 16,
            color: context.customColorTheme.mutedForeground,
          ),
          label: SelectableText(
            widget.label,
            style: context.customTextTheme.textSmMedium.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.customColorTheme.border),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.customColorTheme.border),
          ),
          filled: true,
          fillColor: context.customColorTheme.background,
          contentPadding: const EdgeInsets.all(12),
        ),
        controller: TextEditingController(
          text: _selectedDate != null ? _dateFormat.format(_selectedDate!) : '',
        ),
        style: context.customTextTheme.textSm.copyWith(
          color: context.customColorTheme.cardForeground,
        ),
      ),
    );
  }
}
