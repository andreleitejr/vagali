import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/chat/views/chat_view.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/features/item/widgets/item_info_widget.dart';
import 'package:vagali/features/reservation/controllers/reservation_edit_controller.dart';
import 'package:vagali/features/reservation/controllers/reservation_list_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/carousel_image_slider.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/date_period.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/reservation_status_indicator.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';
import 'package:vagali/widgets/user_card.dart';
import 'package:vagali/widgets/warning_dialog.dart';

class ReservationDetailsView extends StatelessWidget {
  final Reservation reservation;
  /// AJUSTAR POSTERIORMENTE
  final ReservationListController? controller;

  ReservationDetailsView({
    super.key,
    required this.reservation,
    this.controller,
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
          const SizedBox(height: 16),
          Text(
            reservation.parking!.name,
            style: ThemeTypography.semiBold16,
          ),
          const SizedBox(height: 8),
          DatePeriod(
            showTitle: false,
            startDate: reservation.startDate,
            endDate: reservation.endDate,
          ),
          const SizedBox(height: 16),
          UserCard(user: reservation.landlord as User),
          if (controller != null) ...[
            const SizedBox(height: 16),
            ReservationStatusIndicator(controller: controller!),
          ],
          const SizedBox(height: 12),
          const Divider(
            color: ThemeColors.grey2,
            thickness: 1,
          ),
          const SizedBox(height: 12),
          if (reservation.item != null) ...[
            ItemInfoWidget(item: reservation.item!),
          ],
          const SizedBox(height: 16),
          AddressCard(
            isReservationActive: true,
            address: reservation.parking!.address,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ReservationView extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onReservationChanged;

  ReservationView({
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
        children: [
          // Image.network(reservation.item!.image.image),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Row(
                //   children: [
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: Text(
                //         'Placa: ${reservation.item!.licensePlate}',
                //         style: ThemeTypography.semiBold16,
                //       ),
                //     ),
                //     // const Coolicon(
                //     //   icon: Coolicons.starFilled,
                //     //   color: ThemeColors.primary,
                //     // ),
                //     // const SizedBox(width: 4),
                //     // const Text(
                //     //   '4.7',
                //     //   style: ThemeTypography.semiBold16,
                //     // ),
                //     // const SizedBox(width: 8),
                //   ],
                // ),
                const SizedBox(height: 16),
                UserCard(user: reservation.tenant as User),
                const SizedBox(height: 16),
                // if (onReservationChanged != null)
                //   ReservationStatusIndicator(
                //     reservation: reservation,
                //     onReservationChanged: onReservationChanged!,
                //   ),
                const SizedBox(height: 16),
                DatePeriod(
                  startDate: reservation.startDate,
                  endDate: reservation.endDate,
                ),
                const SizedBox(height: 16),
                if (reservation.item != null)
                  // VehicleInfoWidget(vehicle: reservation.item!),
                  const SizedBox(height: 16),
                ..._buildButtonsBasedOnStatus(reservation),
                if (reservation.isPaymentApproved) ...[
                  _buildFlatButton(
                    'Cancelar',
                    () => showWarningDialog(
                      context,
                      title: 'Cancelar reserva',
                      description:
                          'Tem certeza que gostaria de cancelar a reserva?',
                      onConfirm: () {},
                    ),
                    ThemeColors.red,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// JUNTAR COM O CONFIRMATION WIDGET
  List<Widget> _buildButtonsBasedOnStatus(Reservation reservation) {
    List<Widget> buttons = [];

    if (reservation.isPaymentApproved) {
      buttons.add(
        _buildFlatButton(
          'Aceitar',
          onReservationChanged!,
          ThemeColors.primary,
        ),
      );
    }

    if (reservation.isParked) {
      buttons.add(
        _buildFlatButton(
          'Concluir reserva',
          () {},
          ThemeColors.primary,
        ),
      );
    }

    if (reservation.isHandshakeMade) {
      buttons.add(
        _buildFlatButton(
          'Conversar com locatário',
          () => Get.to(() => ChatView(reservation: reservation)),
          ThemeColors.blue,
        ),
      );
    }

    if (reservation.isConcluded) {
      buttons.add(_buildFlatButton(
        'Avaliar locatário',
        () {},
        ThemeColors.blue,
      ));
    }

    return buttons;
  }

  Widget _buildFlatButton(
      String text, VoidCallback onPressed, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FlatButton(
        actionText: text,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
