import 'package:flutter/material.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/date_card.dart';

class ReservationItem extends StatelessWidget {
  final Reservation reservation;

  const ReservationItem({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateCard(date: reservation.startDate),
          ],
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
                "${reservation.tenant?.firstName ?? 'Teste'}"
                " ${reservation.tenant?.lastName ?? 'Teste'}",
                style: ThemeTypography.medium14),
          ),
          Text(
            '+${reservation.totalCost.toMonetaryString()}',
            style: ThemeTypography.medium14.apply(
              color: ThemeColors.primary,
            ),
          ),
        ],
      ),
      subtitle: Text(
        "${reservation.startDate.toFriendlyDateTimeString()}"
        " até ${reservation.endDate.toFriendlyDateTimeString()}",
        style: ThemeTypography.regular10,
      ),
    );
  }
}
