import 'package:flutter/material.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/title_with_icon.dart';

enum DatePeriodType {
  month,
  monthAndYear,
}

class DatePeriod extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  // final DatePeriodType type;

  final bool showTitle;

  const DatePeriod({
    super.key,
    required this.startDate,
    required this.endDate,
    this.showTitle = true,
    // this.type = DatePeriodType.monthAndYear,
  });

  bool get isDateValid => startDate != null && endDate != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          TitleWithIcon(
            title: 'Data de Agendamento',
            icon: ThemeIcons.clock,
          ),
          const SizedBox(height: 4),
        ],
        if (isDateValid) ...[
          Row(
            children: [
              Text(
                startDate!.toDateAndHourDateTimeString(),
                style: ThemeTypography.regular12.apply(
                  color: ThemeColors.grey4,
                ),
              ),
              Expanded(
                child: Icon(
                  Icons.arrow_right_alt,
                  color: ThemeColors.primary,
                ),
              ),
              Text(
                endDate!.toDateAndHourDateTimeString(),
                style: ThemeTypography.regular12.apply(
                  color: ThemeColors.grey4,
                ),
              ),
            ],
          ),
        ] else ...[
          Text(
            'Nenhuma data selecionada',
            style: ThemeTypography.regular14.apply(
              color: ThemeColors.grey4,
            ),
          ),
        ],
      ],
    );
  }
}
