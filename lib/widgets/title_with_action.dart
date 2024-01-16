import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/title_with_icon.dart';

class TitleWithAction extends StatelessWidget {
  final String title;
  final String? icon;
  final String actionText;
  final VoidCallback onActionPressed;

  const TitleWithAction({
    super.key,
    required this.title,
    this.icon,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TitleWithIcon(
              title: title,
              icon: icon,
            ),
          ),
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText,
              style: ThemeTypography.medium14,
            ),
          )
        ],
      ),
    );
  }
}
