import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/theme/theme_colors.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: const Logo(),
                ),
              ),
              const GradientText(
                'Bem-vindo,',
                style: ThemeTypography.semiBold22,
              ),
              const SizedBox(height: 4),
              const Text(
                'Entre com seu número de celular',
                style: ThemeTypography.medium16,
              ),
              const SizedBox(height: 16),
              PhoneInput(
                value: controller.phone.value,
                onSubmit: () async => await controller.sendVerificationCode(),
                onChanged: controller.phone,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      activeColor: ThemeColors.primary,
                      value: controller.termsAndConditions.value,
                      onChanged: controller.termsAndConditions,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Ao clicar em enviar, você concorda com os nossos ',
                        style: ThemeTypography.regular14.apply(
                          color: ThemeColors.grey4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Termos e Condições',
                            style: ThemeTypography.semiBold14.apply(
                              color: ThemeColors.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Adicione aqui a lógica para abrir os Termos e Condições
                                print('Abrir Termos e Condições');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => RoundedGradientButton(
                  actionText: 'Enviar',
                  onPressed: () async {
                    if (controller.isValid.isTrue) {
                      await controller.sendVerificationCode();
                    } else {
                      Get.snackbar(
                        'Erro de autenticação',
                        controller.inputError,
                      );
                    }
                  },
                  isValid: controller.isValid.value,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
