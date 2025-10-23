import 'package:flutter/material.dart';

import 'base_input.dart';

class DateInputApp extends StatelessWidget {
  final String label;
  final String? value;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateChanged;
  final String? Function(String?)? validator;

  const DateInputApp({
    super.key,
    required this.label,
    this.value,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(100),
      child: InputDecorator(
        decoration: InputStyles.getInputDecoration(label),
        child: Text(
          value ?? 'Seleccionar fecha',
          style: TextStyle(color: value != null ? null : Colors.grey[600]),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
    );

    if (date != null) {
      onDateChanged?.call(date);
    }
  }
}
