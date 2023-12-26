import 'package:flutter/material.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/logo.dart';
import 'package:vagali/widgets/phone_input.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';

class LoginView extends StatelessWidget {
  final AuthController controller;

  LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: const Logo(),
              ),
              const SizedBox(
                height: 64,
              ),
              const GradientText(
                'Bem-vindo',
                style: ThemeTypography.semiBold32,
              ),
              const SizedBox(height: 4),
              const Text(
                'Entre com seu número de celular',
                style: ThemeTypography.medium16,
              ),
              const SizedBox(height: 16),
              PhoneInput(
                controller: controller.phoneNumberController,
                onSubmit: () async => await controller.sendVerificationCode(),
              ),
              const SizedBox(height: 16),
              RoundedGradientButton(
                actionText: 'Enviar',
                onPressed: () async => await controller.sendVerificationCode(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
