import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/pin_input.dart';

class CodeWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final String phoneNumber;

  CodeWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.phoneNumber,
  });

  final FocusNode _pinFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinFocusNode);
    });
    return Column(
      children: [
        Text(
          'Verificação',
          style: ThemeTypography.regular14
              .apply(color: const Color(0xFF666666), fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enviamos um código para o número:',
          style: ThemeTypography.medium16,
        ),
        const SizedBox(height: 4),
        GradientText(
          phoneNumber,
          style: ThemeTypography.medium14,
        ),
        const SizedBox(height: 16),
        PinInput(
          controller: controller,
          focusNode: _pinFocusNode,
          onChanged: (pin) {},
          onSubmit: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
