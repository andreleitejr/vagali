import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rive/rive.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/theme/animations.dart';
import 'package:vagali/theme/theme_colors.dart';

class AnimationView extends StatefulWidget {
  const AnimationView({super.key, required this.controller});

  final AuthController controller;

  @override
  State<AnimationView> createState() => _AnimationViewState();
}

class _AnimationViewState extends State<AnimationView> {
  late RiveAnimationController openController;

  final String animation = 'open';

  @override
  void initState() {
    openController = OneShotAnimation(
      animation,
      autoplay: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.gradient,
        ),
        child: Center(
          child: SizedBox(
            width: 95,
            height: 120,
            child: RiveAnimation.asset(
              Animations.logo,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              animations: [animation],
              controllers: [
                openController,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
