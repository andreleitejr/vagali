import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';

class DashboardCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String content;
  final Color cardColor;
  final Color contentColor;

  const DashboardCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.cardColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: cardColor,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Coolicon(
                    icon: icon,
                    color: iconColor,
                    width: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: ThemeTypography.regular12.apply(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                content,
                style: ThemeTypography.semiBold22.apply(
                  color: contentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}