import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/views/reservation_details_view.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/date_card.dart';

class ReservationDoneItem extends StatelessWidget {
  final Reservation reservation;
  final bool isMonetary;

  const ReservationDoneItem({
    super.key,
    required this.reservation,
    this.isMonetary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => ReservationView(reservation: reservation)),
          leading: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: ThemeColors.grey1,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DateCard(date: reservation.startDate),
              ],
            ),
          ),
          title: Row(
            children: [
              Text(
                  "${reservation.tenant?.firstName}'"
                  " ${reservation.tenant?.lastName}",
                  style: ThemeTypography.medium14),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                "${reservation.startDate.toMonthlyFormattedString()}"
                " até ${reservation.endDate.toMonthlyFormattedString()}",
                style: ThemeTypography.regular10,
              ),
              const SizedBox(height: 4),
              Text(
                reservation.status.title,
                style: ThemeTypography.semiBold12.apply(
                  color: reservation.status.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class ReservationItem extends StatelessWidget {
  final Reservation reservation;
  final bool isMonetary;

  const ReservationItem({
    super.key,
    required this.reservation,
    this.isMonetary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to(() => ReservationView(reservation: reservation)),
      leading: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: ThemeColors.grey1,
          borderRadius: BorderRadius.circular(8),
        ),
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
              "${reservation.tenant?.firstName}'"
              " ${reservation.tenant?.lastName}",
              style: ThemeTypography.semiBold14,
            ),
          ),
          Text(
            isMonetary
                ? '${!reservation.isCanceled ? '+' : '-'}'
                    '${UtilBrasilFields.obterReal(reservation.totalCost)}'
                : reservation.status.title,
            style: ThemeTypography.semiBold12.apply(
              color: reservation.status.color,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${reservation.startDate.toFormattedString()}"
            " até ${reservation.endDate.toFormattedString()}",
            style: ThemeTypography.regular10,
          ),
          const SizedBox(height: 2),
          Text(
            "Status da Reserva: ${reservation.status.title}",
            style: ThemeTypography.medium10.apply(
              color: reservation.status.color,
            ),
          ),
        ],
      ),
    );
  }
}
