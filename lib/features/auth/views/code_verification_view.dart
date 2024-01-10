import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/widgets/code_widget.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/logo.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';

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
              const SizedBox(
                height: 64,
              ),
              CodeWidget(
                value: controller.sms.value,
                onSubmit: () async => await controller.verifySmsCode(),
                phoneNumber: controller.phone.value,
                onChanged: controller.sms,
              ),
              Obx(
                () => FlatButton(
                  actionText: 'Verificar Código',
                  onPressed: () async {
                    if (controller.isValid.isTrue) {
                      await controller.verifySmsCode();
                    } else {
                      Get.snackbar(
                        'Erro com SMS',
                        controller.inputError,
                      );
                    }
                  },
                  isValid: controller.isSmsValid.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
