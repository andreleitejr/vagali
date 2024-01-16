import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';

class LocationDeniedView extends StatelessWidget {
  const LocationDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const GradientText(
              'Localização nega',
              style: ThemeTypography.semiBold22,
            ),
            Image.asset(
              Images.disconnected,
            ),
            const Text(
              'Para que o Vagali te proporcione a melhor experiência de usa, precisamos da sua localização. Permita o acesso à localização nas configurações e tente novamente.',
              style: ThemeTypography.regular16,
            ),
            RoundedGradientButton(
                actionText: 'Ir para configurações',
                onPressed: () => AppSettings.openAppSettings()),
          ],
        ),
      ),
    );
  }
}
