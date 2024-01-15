import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';

class AuthErrorView extends StatelessWidget {
  final String error;

  const AuthErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.75,
              child: Image.asset(
                Images.empty,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Um erro inesperado ocorreu durante o login',
              style: ThemeTypography.regular14.apply(
                color: ThemeColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            FlatButton(
              actionText: 'Voltar ao login',
              onPressed: () => Get.back(),
              // isValid: controller.isSmsValid.value,
            ),
          ],
        ));
  }
}
