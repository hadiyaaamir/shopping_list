import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.errorText,
    required this.onChanged,
    this.obsecureText = false,
    this.maxLines = 1,
    this.initialValue,
  });

  final String label;
  final String? errorText;
  final Function(String) onChanged;
  final bool obsecureText;
  final int maxLines;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obsecureText,
      maxLines: maxLines,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        alignLabelWithHint: true,
      ),
    );
  }
}
