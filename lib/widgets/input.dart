import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final String? error;
  final VoidCallback? onTap;
  final bool required;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? onSubmit;

  Input({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.error,
    this.onTap,
    this.required = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
    this.currentFocusNode,
    this.nextFocusNode,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: currentFocusNode,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: ThemeTypography.medium14.apply(
            color: enabled ? ThemeColors.primary : ThemeColors.grey3,
          ),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 16, top: maxLines > 1 ? 20 : 0),
            hintText: '$hintText${required ? ' *' : ''}',
            hintStyle:
                ThemeTypography.regular14.apply(color: ThemeColors.grey4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            fillColor: ThemeColors.grey1,
            filled: true,
          ),
          onTap: onTap,
          onEditingComplete: () {
            if (onSubmit != null) {
              onSubmit?.call();
              return;
            }
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
        if (error != null && error!.isNotEmpty) ...[
          Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}

class Input2 extends StatelessWidget {
  final String value;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final String? error;
  final VoidCallback? onTap;
  final bool required;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? onSubmit;
  final Function(String) onChanged;

  final TextEditingController controller;

  Input2({
    super.key,
    required this.value,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.error,
    this.onTap,
    this.required = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
    this.currentFocusNode,
    this.nextFocusNode,
    this.onSubmit,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    controller.text = value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: currentFocusNode,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: ThemeTypography.regular14
              .apply(color: enabled ? ThemeColors.primary : ThemeColors.grey4),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 16, top: maxLines > 1 ? 20 : 0),
            hintText: '$hintText${required ? ' *' : ''}',
            hintStyle:
                ThemeTypography.regular14.apply(color: ThemeColors.grey3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            fillColor: ThemeColors.grey1,
            filled: true,
          ),
          onChanged: (text) {
            print(text);
            onChanged(text);
            // controller.text = text;
          },
          onTap: onTap,
          onEditingComplete: () {
            if (onSubmit != null) {
              onSubmit?.call();
              return;
            }
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
        if (error != null && error!.isNotEmpty) ...[
          Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
