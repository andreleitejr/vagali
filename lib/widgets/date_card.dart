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
          style: ThemeTypography.semiBold12.apply(
            color: ThemeColors.primary,
          ),
        ),
        Text(
          date.day.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        )
      ],
    );
  }
}

class HourCard extends StatelessWidget {
  final DateTime date;

  const HourCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          date.hour.toString(),
          style: ThemeTypography.semiBold22.apply(
            color: ThemeColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'hrs',
          style: ThemeTypography.regular12.apply(
            color: ThemeColors.grey4,
          ),
        )
      ],
    );
  }
}
