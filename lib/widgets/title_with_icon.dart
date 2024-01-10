import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';

class TitleWithIcon extends StatelessWidget {
  final String title;
  final String? icon;

  const TitleWithIcon({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Coolicon(
            icon: icon!,
            color: Colors.black,
          ),
        const SizedBox(width: 4),
        Text(
          title,
          style: ThemeTypography.semiBold16,
        ),
      ],
    );
  }
}
