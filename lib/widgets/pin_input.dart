import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:vagali/theme/theme_colors.dart';

class PinInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmit;

  PinInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return PinInputTextField(
      pinLength: 6,
      keyboardType: TextInputType.number,
      decoration: BoxLooseDecoration(
        strokeColorBuilder: PinListenColorBuilder(
          ThemeColors.grey2,
          Colors.grey,
        ),
        bgColorBuilder: PinListenColorBuilder(
          ThemeColors.grey1,
          ThemeColors.grey1,
        ),
      ),
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      onSubmit: onSubmit,
    );
  }
}
