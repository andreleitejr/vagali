import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:vagali/theme/theme_colors.dart';

class Loader extends StatelessWidget {
  final Color dotColor;

  const Loader({super.key, this.dotColor = ThemeColors.primary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: JumpingDots(
        verticalOffset: -7,
        color: dotColor,
        radius: 6,
        numberOfDots: 3,
        // animationDuration = Duration(milliseconds: 200),
      ),
    );
  }
}


