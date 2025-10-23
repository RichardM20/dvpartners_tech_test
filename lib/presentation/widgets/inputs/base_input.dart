import 'package:flutter/material.dart';

abstract class InputStyles {
  static InputDecoration getInputDecoration(String label) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600, width: 0.5),
      borderRadius: BorderRadius.circular(100),
    );
    return InputDecoration(
      labelText: label,
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
