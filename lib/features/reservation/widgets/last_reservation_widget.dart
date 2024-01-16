import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/views/reservation_details_view.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/date_period.dart';
import 'package:vagali/widgets/reservation_status_indicator.dart';
import 'package:vagali/widgets/user_card.dart';

// ignore: must_be_immutable
class LastReservationWidget extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onReservationChanged;

  LastReservationWidget({
    super.key,
    required this.reservation,
    required this.onReservationChanged,
  });

  final carouselController = CarouselController();
  var currentCarouselImage = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            ThemeColors.primary.withOpacity(0.15),
            ThemeColors.blue.withOpacity(0.15),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próxima reserva',
                      style: ThemeTypography.regular12
                          .apply(color: ThemeColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // const SizedBox(width: 8),
                        Text(
                          reservation.parking!.name.toUpperCase(),
                          style: ThemeTypography.semiBold16,
                        ),
                        const SizedBox(width: 8),
                        const Coolicon(
                          icon: Coolicons.starFilled,
                          color: ThemeColors.primary,

                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4.7',
                          style: ThemeTypography.semiBold16,
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Get.to(
                  () => ReservationView(
                      reservation: reservation,
                      onReservationChanged: onReservationChanged),
                ),
                child: Text('Ver mais'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                  // backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          UserCard(user: reservation.landlord as User),
          const SizedBox(height: 16),
          DatePeriod(
            startDate: reservation.startDate,
            endDate: reservation.endDate,
          ),
          const SizedBox(height: 16),
          ReservationStatusIndicator(
            reservation: reservation,
            onReservationChanged: onReservationChanged,
          ),
          const SizedBox(height: 16),
          // const SizedBox(height: 16),
          // if (reservation.vehicle != null)
          //   VehicleInfoWidget(vehicle: reservation.vehicle!),
          // const SizedBox(height: 16),
          // AddressCard(
          //   address: reservation.parking!.address,
          //   editionModeOn: false,
          // ),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }
}
