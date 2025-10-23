import 'package:flutter/material.dart';

import 'base_input.dart';

class TextInputApp extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const TextInputApp({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: InputStyles.getInputDecoration(label),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
