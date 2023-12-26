import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/widgets/vehicle_info_widget.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/carousel_image_slider.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/date_period.dart';
import 'package:vagali/widgets/reservation_status_indicator.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';
import 'package:vagali/widgets/user_card.dart';

class ReservationDetailsView extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onReservationChanged;

  ReservationDetailsView({
    super.key,
    required this.reservation,
    this.onReservationChanged,
  });

  final carouselController = CarouselController();
  final currentCarouselImage = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopNavigationBar(
        title: 'Próxima reserva',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CarouselImageSlider(
                images: reservation.parking!.images,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reservation.parking!.name,
                  style: ThemeTypography.semiBold16,
                ),
              ),
              const Coolicon(
                icon: Coolicons.starFilled,
                color: ThemeColors.primary,
                scale: 1.25,
              ),
              const SizedBox(width: 4),
              const Text(
                '4.7',
                style: ThemeTypography.semiBold16,
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
          UserCard(user: reservation.landlord as User),
          const SizedBox(height: 16),
          if (onReservationChanged != null)
            ReservationStatusIndicator(
              reservation: reservation,
              onReservationChanged: onReservationChanged!,
            ),
          const SizedBox(height: 16),
          DatePeriod(
            startDate: reservation.startDate,
            endDate: reservation.endDate,
          ),
          const SizedBox(height: 16),
          if (reservation.vehicle != null)
            VehicleInfoWidget(vehicle: reservation.vehicle!),
          const SizedBox(height: 16),
          AddressCard(
            address: reservation.parking!.address,
            editionModeOn: false,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
