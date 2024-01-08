import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';

class DateCard extends StatelessWidget {
  final DateTime date;

  const DateCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          date.monthAbbreviation,
          style: ThemeTypography.regular12.apply(
            color: ThemeColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          date.day.toString(),
          style: ThemeTypography.semiBold22.apply(
            color: ThemeColors.grey4,
          ),
        )
      ],
    );
  }
}
