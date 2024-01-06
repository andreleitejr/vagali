import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagali/widgets/input.dart';

class InputButton extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final String? error;
  final VoidCallback onTap;
  final bool required;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;

  const InputButton({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.error,
    required this.onTap,
    this.required = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Input(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          error: error,
          required: required,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          enabled: enabled,
        ),
      ),
    );
  }
}

class InputButton2 extends StatelessWidget {
  final String value;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final String? error;
  final VoidCallback onTap;
  final bool required;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;
  final Function(String) onSelected;
  final TextEditingController controller;

  const InputButton2({
    super.key,
    required this.value,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.error,
    required this.onTap,
    this.required = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
    required this.onSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Input2(
          controller: controller,
          value: value,
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          error: error,
          required: required,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          enabled: enabled,
          onChanged: onSelected,
        ),
      ),
    );
  }
}
