import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/item/widgets/item_info_widget.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/features/reservation/controllers/reservation_list_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/views/reservation_details_view.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';
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
                        Text(
                          reservation.parking!.name,
                          style: ThemeTypography.semiBold14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Get.to(
                  () => ReservationDetailsView(
                    reservation: reservation,
                    controller: controller,
                  ),
                ),
                child: Text(
                  'Detalhes',
                  style: ThemeTypography.regular12,
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                  // backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DatePeriod(
            showTitle: false,
            startDate: reservation.startDate,
            endDate: reservation.endDate,
          ),
          const SizedBox(height: 16),
          UserCard(user: reservation.landlord as User),
          const SizedBox(height: 16),
          ReservationStatusIndicator(controller: controller),
          // const SizedBox(height: 12),
          // const Divider(
          //   color: ThemeColors.grey2,
          //   thickness: 1,
          // ),
          // const SizedBox(height: 12),
          // if (reservation.item != null) ...[
          //   ItemInfoWidget(item: reservation.item as Vehicle),
          // ],
          // const SizedBox(height: 16),
          // AddressCard(
          //   isReservationActive: true,
          //   address: reservation.parking!.address,
          // ),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getItemTitle() {
    if (reservation.item != null) {
      final item = reservation.item!;

      if (item.type == ItemType.vehicle) {
        final vehicle = reservation.item as Vehicle;
        return '${vehicle.brand} ${vehicle.model} (${vehicle.licensePlate})';
      }
    }

    return itemTypes
        .firstWhere((item) => item.type == reservation.item!.type)
        .name!;
  }
}
