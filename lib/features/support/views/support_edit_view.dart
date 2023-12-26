import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/support/controllers/support_edit_controller.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/switch_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class SupportEditView extends StatelessWidget {
  final controller = Get.put(SupportEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Suporte',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                return Input(
                  controller: controller.subjectController,
                  hintText: 'Assunto',
                  required: true,
                  error: controller.subjectError.value,
                );
              }),
              const SizedBox(height: 16),
              Obx(
                () => Input(
                  controller: controller.descriptionController,
                  hintText: 'Descrição do problema',
                  required: true,
                  error: controller.getError(controller.descriptionError),
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return Input(
                  controller: controller.phoneController,
                  hintText: 'Telefone para contato',
                  required: true,
                  error: controller.phoneError.value,
                );
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'O número inserido permite contato via WhatsApp?',
                      style: ThemeTypography.regular12.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ),
                  Obx(
                    () => SwitchButton(
                      value: controller.isWhatsAppController.value,
                      onChanged: controller.isWhatsAppController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              RoundedGradientButton(
                actionText: 'Solicitar Suporte',
                onPressed: () async {
                  final result = await controller.save();
                  if (result == SaveResult.success) {
                    Get.back();
                    Get.snackbar(
                      'Suporte enviado',
                      'Seu pedido de suporte foi enviado com sucesso'
                          ' Entraremos em contato após a análise.'
                          ' Desde já, muito obrigado.',
                      backgroundColor: ThemeColors.primary,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'Erro inesperado',
                      'Um erro inesperado ocorreu. Tente novamente.',
                      backgroundColor: ThemeColors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
              Obx(() {
                if (controller.isWhatsAppController.isFalse) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const SizedBox(height: 16),
                      Text(
                        'Aviso: entraremos em contato pelo e-mail ${controller.user.email}',
                        style: ThemeTypography.regular12.apply(
                          color: ThemeColors.primary,
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
