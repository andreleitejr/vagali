import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rive/rive.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/theme/animations.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/theme/theme_colors.dart';

class AnimationView extends StatefulWidget {
  const AnimationView({super.key});

  @override
  State<AnimationView> createState() => _AnimationViewState();
}

class _AnimationViewState extends State<AnimationView> {
  late RiveAnimationController openController;

  final open = 'open';

  @override
  void initState() {
    openController = OneShotAnimation(
      open,
      autoplay: true,
    );
    super.initState();
  }

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    focus.unfocus();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.height * 100) / 1152),
        decoration: BoxDecoration(
          color: ThemeColors.primary,
        ),
        alignment: Alignment.center,
        child: RiveAnimation.asset(
          Animations.logo,
          // fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          useArtboardSize: true,
          animations: [open],
          controllers: [
            openController,
          ],
        ),
      ),
    );
  }
}
