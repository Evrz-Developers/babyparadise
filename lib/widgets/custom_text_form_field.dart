import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final List<String>? autofillHints; // Optional autofill hints

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    this.obscureText = false,
    required this.onChanged,
    required this.validator,
    this.autofillHints, // Accept autofill hints as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.inversePrimary,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      autofillHints: autofillHints, // Use autofill hints if provided

    );
  }
}
