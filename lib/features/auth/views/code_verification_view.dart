import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/widgets/code_widget.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/logo.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/snackbar.dart';

class CodeVerificationView extends StatelessWidget {
  final AuthController controller;

  CodeVerificationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: const Logo(),
                ),
              ),
              const SizedBox(height: 64),
              CodeWidget(
                value: controller.sms.value,
                onSubmit: () => verifySmsCode(),
                phoneNumber: controller.phone.value,
                onChanged: controller.sms,
              ),
              Obx(
                () => FlatButton(
                  actionText: 'Verificar Código',
                  onPressed: () => verifySmsCode(),
                  isValid: controller.isSmsValid.value,
                ),
              ),
              const SizedBox(height: 16),
              if (controller.authStatus.value == AuthStatus.verifying) ...[
                Text(
                  'Verificando os dados...',
                  style: ThemeTypography.semiBold12.apply(
                    color: ThemeColors.primary,
                  ),
                ),
              ] else ...[
                Obx(
                  () => TextButton(
                    onPressed: () async {
                      if (controller.isCountdownFinished.isTrue) {
                        await controller.sendVerificationCode();
                        snackBar('Novo código enviado',
                            'Um novo SMS foi enviado ao número ${controller.phone.value}');
                      }
                    },
                    child: Text(
                      'Reenviar código '
                      '(${controller.minutes.value.toString().padLeft(2, '0')}'
                      ':${controller.seconds.value.toString().padLeft(2, '0')})',
                      style: controller.isCountdownFinished.isTrue
                          ? ThemeTypography.semiBold14.apply(
                              color: ThemeColors.primary,
                            )
                          : ThemeTypography.regular14.apply(
                              color: ThemeColors.grey4,
                            ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifySmsCode() async {
    if (controller.isValid.isTrue) {
      final result = await controller.verifySmsCode();
      if (result != AuthStatus.authenticatedAsTenant ||
          result != AuthStatus.authenticatedAsLandlord) {
        Get.snackbar(
          'Erro com SMS',
          'Erro ao validar o SMS. Tente novamente.',
        );
      }
    } else {
      Get.snackbar(
        'Erro com SMS',
        controller.inputError,
      );
    }
  }
}
