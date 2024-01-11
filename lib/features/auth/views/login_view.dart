import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/legal/terms_and_conditions.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/logo.dart';
import 'package:vagali/widgets/phone_input.dart';

import 'package:vagali/widgets/snackbar.dart';

class LoginView extends StatelessWidget {
  final AuthController controller;

  LoginView({super.key, required this.controller});

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    focus.requestFocus();
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
                style: ThemeTypography.semiBold16,
              ),
              const SizedBox(height: 4),
              const Text(
                'Entre com seu número de celular',
                style: ThemeTypography.regular14,
              ),
              const SizedBox(height: 16),
              PhoneInput(
                focus: focus,
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
                        style: ThemeTypography.regular12.apply(
                          color: ThemeColors.grey4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Termos e Condições',
                            style: ThemeTypography.semiBold12.apply(
                              color: ThemeColors.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => TermsAndConditions(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => FlatButton(
                  actionText: 'Enviar',
                  onPressed: () async {
                    if (controller.isLoginValid.isTrue) {
                      await controller.sendVerificationCode();
                    } else {
                      snackBar(
                        'Erro de autenticação',
                        controller.inputError,
                        icon: Coolicon(
                          icon: Coolicons.squareWarning,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                  isValid: controller.isLoginValid.value,
                ),
              ),
              // Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
