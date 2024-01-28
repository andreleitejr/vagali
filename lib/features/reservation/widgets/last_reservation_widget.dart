import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/reservation/controllers/reservation_list_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/views/reservation_details_view.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/date_period.dart';
import 'package:vagali/widgets/reservation_status_indicator.dart';
import 'package:vagali/widgets/title_with_icon.dart';
import 'package:vagali/widgets/user_card.dart';

// ignore: must_be_immutable
class LastReservationWidget extends StatelessWidget {
  final ReservationListController controller;

  LastReservationWidget({
    super.key,
    required this.controller,
  });

  Reservation get reservation => controller.currentReservation.value!;
  final carouselController = CarouselController();
  var currentCarouselImage = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: reservation.isUserOnTheWay
              ? ThemeColors.primary
              : ThemeColors.grey2,
          width: reservation.isUserOnTheWay ? 1.5 : 1,
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
                      style: ThemeTypography.regular12,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // const SizedBox(width: 8),
                        Text(
                          reservation.parking!.name.toUpperCase(),
                          style: ThemeTypography.semiBold14,
                        ),
                        const SizedBox(width: 8),
                        const Coolicon(
                          icon: Coolicons.starFilled,
                          color: ThemeColors.primary,
                          width: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4.7',
                          style: ThemeTypography.semiBold14,
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ],
                ),
              ),
              // TextButton(
              //   onPressed: () => Get.to(
              //     () => ReservationView(
              //         reservation: reservation,
              //         onReservationChanged: onReservationChanged),
              //   ),
              //   child: Text('Ver mais'),
              //   style: TextButton.styleFrom(
              //     padding: EdgeInsets.zero,
              //     alignment: Alignment.topRight,
              //     // backgroundColor: Colors.blue,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),
          UserCard(user: reservation.landlord as User),
          const SizedBox(height: 16),
          DatePeriod(
            startDate: reservation.startDate,
            endDate: reservation.endDate,
          ),
          const SizedBox(height: 8),

          const Divider(
            color: ThemeColors.grey2,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          TitleWithIcon(
            title: 'O que vou guardar',
            icon: Coolicons.circleCheckOutline,
          ),
          const SizedBox(height: 8),
          Text(
            itemTypes
                .firstWhere((item) => item.type == reservation.item!.type)
                .name!,
          ),
          const SizedBox(height: 24),
          ReservationStatusIndicator(controller: controller),
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
