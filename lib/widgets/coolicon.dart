import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';

class Coolicon extends StatelessWidget {
  final String icon;
  final Color color;
  final double scale;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const Coolicon({
    super.key,
    required this.icon,
    this.color = ThemeColors.grey4,
    this.scale = 1,
    this.onTap,
    this.padding = const EdgeInsets.all(0),
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
            scale: scale,
          ),
        ),
      ),
    );
  }
}
