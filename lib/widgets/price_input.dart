import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';

class PriceInput extends StatelessWidget {
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
  final TextEditingController controller;

  PriceInput({
    super.key,
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
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 58,
                decoration: BoxDecoration(
                  color: ThemeColors.grey2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Text(
                  hintText,
                  style: ThemeTypography.semiBold16,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                focusNode: currentFocusNode,
                enabled: enabled,
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                inputFormatters: inputFormatters,
                maxLines: maxLines,
                textAlign: TextAlign.center,
                style: ThemeTypography.medium16.apply(
                  color: ThemeColors.intermediary,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
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
            ),
          ],
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
