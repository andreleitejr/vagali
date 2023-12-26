import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/views/user_edit_view.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/logo.dart';

class SelectTypeView extends StatelessWidget {
  SelectTypeView({super.key});

  final RxString description = ''.obs;

  final tenantDescription = 'Quero uma vaga para o meu veículo';
  final landlordDescription = 'Quero alugar a minha vaga';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Center(
                  child: Logo(),
                ),
              ),
              const GradientText(
                'Celular confirmado',
                style: ThemeTypography.semiBold32,
              ),
              const SizedBox(height: 4),
              const Text(
                'Seja bem-vindo ao Vagali. Vamos começar?',
                style: ThemeTypography.medium16,
              ),
              const SizedBox(height: 32),
              FlatButton(
                onPressed: () =>
                    Get.to(() => const UserEditView(type: UserType.tenant)),
                actionText: tenantDescription,
              ),
              const SizedBox(height: 16),
              FlatButton(
                onPressed: () =>
                    Get.to(() => const UserEditView(type: UserType.landlord)),
                actionText: landlordDescription,
                backgroundColor: ThemeColors.blue,
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
