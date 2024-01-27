import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/widgets/code_widget.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/logo.dart';
import 'package:vagali/widgets/snackbar.dart';

class CodeVerificationView extends StatelessWidget {
  final AuthController controller;

  CodeVerificationView({super.key, required this.controller});

  final _pinFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _pinFocus.requestFocus();
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
                onSubmit: () => controller.verifySmsCode(),
                phoneNumber: controller.phone.value,
                onChanged: controller.sms,
                focusNode: _pinFocus,
              ),
              Obx(
                () {
                  final isVerifying =
                      controller.authStatus.value == AuthStatus.verifying;

                  return FlatButton(
                    actionText: isVerifying
                        ? 'Verificando os dados...'
                        : 'Verificar código',
                    onPressed: () async {
                      await controller.verifySmsCode();

                      _pinFocus.unfocus();
                    },
                    isValid: controller.isSmsValid.value,
                    backgroundColor: isVerifying
                        ? ThemeColors.secondary
                        : ThemeColors.primary,
                  );
                },
              ),
              const SizedBox(height: 16),
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
                    controller.authStatus.value != AuthStatus.verifying
                        ? 'Reenviar código '
                            '(${controller.minutes.value.toString().padLeft(2, '0')}'
                            ':${controller.seconds.value.toString().padLeft(2, '0')})'
                        : '',
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
          ),
        ),
      ),
    );
  }
}
