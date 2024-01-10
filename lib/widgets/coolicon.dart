import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';

class Coolicon extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double width;
  final double height;

  const Coolicon({
    super.key,
    required this.icon,
    this.color = ThemeColors.grey4,
    this.onTap,
    this.padding = const EdgeInsets.all(0),
    this.width = 24,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            icon,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}
