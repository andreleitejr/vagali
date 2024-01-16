import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/views/reservation_details_view.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/date_period.dart';

class ReservationHistoryItem extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onReservationChanged;

  const ReservationHistoryItem({
    super.key,
    required this.reservation,
    this.onReservationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => ReservationView(
          reservation: reservation,
          onReservationChanged: onReservationChanged,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: ThemeColors.grey2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BlurHash(
                  imageFit: BoxFit.cover,
                  image: reservation.parking!.images.first.image,
                  hash: reservation.parking!.images.first.blurHash,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reservation.parking!.name,
                          style: ThemeTypography.semiBold14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        reservation.status.title,
                        style: ThemeTypography.semiBold14.apply(
                          color: reservation.status.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  DatePeriod(
                    startDate: reservation.startDate,
                    endDate: reservation.endDate,
                    showTitle: false,
                    // type: DatePeriodType.month,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preço total: R\$${reservation.totalCost}',
                    style: ThemeTypography.semiBold14,
                  ),

                  // Row(
                  //   children: [
                  //     const Icon(Icons.star, size: 16.0),
                  //     const Text(' 4.7'),
                  //     const SizedBox(width: 8.0),
                  //     Text(
                  //         '\$${reservation.pricePerHour.toStringAsFixed(2)} / hora'),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
