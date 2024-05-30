import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:rive/rive.dart';
import 'package:vagali/theme/animations.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

class Loader extends StatefulWidget {
  final String? message;

  const Loader({super.key, this.message});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  late RiveAnimationController openController;

  final loading = 'loading';

  @override
  void initState() {
    openController = OneShotAnimation(
      loading,
      autoplay: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.height * 100) / 1152),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RiveAnimation.asset(
            Animations.loading,
            // fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            useArtboardSize: true,
            animations: [loading],
            controllers: [
              openController,
            ],
          ),
          if (widget.message != null)
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                widget.message!,
                style: ThemeTypography.semiBold14.apply(
                  color: ThemeColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
