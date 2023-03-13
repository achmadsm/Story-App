import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hitText,
    this.keyboardType,
    this.obscureText,
    required this.validator,
    this.maxLines,
  });

  final TextEditingController controller;
  final String hitText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final FormFieldValidator validator;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hitText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      validator: validator,
      maxLines: maxLines ?? 1,
    );
  }
}
