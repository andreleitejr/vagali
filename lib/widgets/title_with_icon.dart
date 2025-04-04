import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';

class TitleWithIcon extends StatelessWidget {
  final String title;
  final String? icon;

  const TitleWithIcon({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          CustomIcon(
            icon: icon!,
            color: Colors.black,
            width: 18,
          ),
        const SizedBox(width: 4),
        Text(
          title,
          style: ThemeTypography.semiBold14,
        ),
      ],
    );
  }
}
