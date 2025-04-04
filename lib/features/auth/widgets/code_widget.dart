import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/pin_input.dart';

class CodeWidget extends StatelessWidget {
  final String value;
  final VoidCallback onSubmit;
  final String phoneNumber;
  final Function(String) onChanged;
  final FocusNode focusNode;

  CodeWidget({
    super.key,
    required this.value,
    required this.onSubmit,
    required this.phoneNumber,
    required this.onChanged,
    required this.focusNode,
  });

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verificação',
          style: ThemeTypography.regular14
              .apply(color: const Color(0xFF666666), fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enviamos um código para o número:',
          style: ThemeTypography.medium14,
        ),
        const SizedBox(height: 4),
        Text(
          phoneNumber,
          style: ThemeTypography.medium14.apply(
            color: ThemeColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        PinInput(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmit: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
