import 'package:flutter/material.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';

class ConfigListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ConfigListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: ThemeTypography.medium14,
      ),
      trailing: CustomIcon(
        icon: ThemeIcons.chevronRight,
      ),
      onTap: onTap,
    );
  }
}
