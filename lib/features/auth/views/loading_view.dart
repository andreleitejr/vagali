import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/loader.dart';

class LoadingView extends StatefulWidget {
  // const LoadingView({super.key, required this.controller});
  //
  // final AuthController controller;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  // late RiveAnimationController openController;
  //
  // final String animation = 'open';

  @override
  void initState() {
    // openController = OneShotAnimation(
    //   animation,
    //   autoplay: true,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Loader(),
            const SizedBox(height: 16),
            GradientText(
              'Verificando informações de usuário',
              style: ThemeTypography.semiBold14,
            )
          ],
        ));
  }
}
