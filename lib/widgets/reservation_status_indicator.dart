import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_details_view.dart';
import 'package:vagali/apps/tenant/features/payment/views/payment_view.dart';
import 'package:vagali/features/chat/views/chat_view.dart';
import 'package:vagali/features/reservation/controllers/reservation_list_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/title_with_icon.dart';

class ReservationStatusIndicator extends StatelessWidget {
  final ReservationListController controller;

  ReservationStatusIndicator({Key? key, required this.controller})
      : super(key: key);

  Reservation get reservation => controller.currentReservation.value!;

  bool get isRed =>
      reservation.isCanceled ||
      reservation.isPaymentDenied ||
      reservation.isPaymentTimeOut ||
      reservation.isPendingPayment ||
      reservation.isError;

  bool get isYellow => reservation.isPaymentApproved;

  bool get isGreen => reservation.isHandshakeMade || reservation.isConcluded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _containerDecoration(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusRow(),
          const SizedBox(height: 8),
          _buildStatusMessage(),
          const SizedBox(height: 16),
          ..._buildButtonsBasedOnStatus(),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: ThemeColors.grey1,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: ThemeColors.grey2,
      ),
    );
  }

  Row _buildStatusRow() {
    return Row(
      children: [
        Expanded(
          child: TitleWithIcon(
            title: "Status da Reserva",
            icon: Coolicons.circleCheckOutline,
          ),
        ),
        Row(
          children: [
            _buildStatusIndicator(_firstCircleColor()),
            _buildStatusIndicator(_secondCircleColor()),
            _buildStatusIndicator(_thirdCircleColor()),
          ],
        ),
      ],
    );
  }

  Color _firstCircleColor() {
    if (isRed) {
      return Colors.red;
    }
    return ThemeColors.grey2;
  }

  Color _secondCircleColor() {
    if (isYellow) {
      return Colors.amber;
    }
    return ThemeColors.grey2;
  }

  Color _thirdCircleColor() {
    if (isGreen) {
      return ThemeColors.primary;
    }
    return ThemeColors.grey2;
  }

  Text _buildStatusMessage() {
    return Text(
      controller.currentReservation.value!.status.message,
      style: controller.currentReservation.value!.status ==
              ReservationStatus.concluded
          ? ThemeTypography.medium14.apply(color: _textColor())
          : ThemeTypography.regular14.apply(color: _textColor()),
    );
  }

  Color _textColor() {
    if (controller.currentReservation.value!.isConfirmed) {
      return ThemeColors.primary;
    } else if (controller.currentReservation.value!.isPaymentDenied) {
      return Colors.red;
    }
    return ThemeColors.grey4;
  }

  List<Widget> _buildButtonsBasedOnStatus() {
    List<Widget> buttons = [];

    if (reservation.isConfirmed) {
      buttons.add(
        _buildFlatButton('Estou à caminho', () async {
          await controller.updateReservation(ReservationStatus.userOnTheWay);
          print('Calling startLocationTracking');
          await Future.delayed(const Duration(seconds: 2));
          controller
              .startLocationTracking(controller.currentReservation.value!);
          print('startLocationTracking completed');
        }, ThemeColors.primary),
      );
    }

    if (reservation.isUserOnTheWay) {
      buttons.add(
        _buildFlatButton(
          'Confirmar estacionamento',
          () {
            controller.updateReservation(ReservationStatus.parked);
          },
          ThemeColors.primary,
        ),
      );
      buttons.add(
        _buildFlatButton('Abrir no Waze', openWaze, ThemeColors.secondary),
      );

    }

    if (reservation.isPaymentTimeOut) {
      buttons.add(
        _buildFlatButton(
          'Fazer nova reserva',
          () => Get.to(
            () => ParkingDetailsView(
              parking: reservation.parking!,
            ),
          ),
          ThemeColors.primary,
        ),
      );
    }

    if (reservation.isPaymentDenied) {
      buttons.add(
        _buildFlatButton(
          'Tentar novo pagamento',
          () => Get.to(
            () => PaymentView(
              reservation: reservation,
            ),
          ),
          Colors.red,
        ),
      );
    }

    if (reservation.isHandshakeMade) {
      buttons.add(
        _buildFlatButton(
          'Conversar com locatário',
          () => Get.to(
            () => ChatView(
              reservation: reservation,
            ),
          ),
          ThemeColors.blue,
        ),
      );
    }

    // if (reservation.isConcluded) {
    //   buttons.add(
    //     _buildFlatButton(
    //       'Avaliar experiência',
    //       () {},
    //       ThemeColors.blue,
    //     ),
    //   );
    // }

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

  Widget _buildStatusIndicator(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      margin: const EdgeInsets.only(left: 8),
    );
  }

  void openWaze() async {
    final latitude = reservation.parking?.location.latitude;
    final longitude = reservation.parking?.location.longitude;
    final uri = Uri.parse(
        "waze://?ll=${latitude.toString()},${longitude.toString()}&navigate=yes");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Coordenadas inválidas',
          'Parece que houve um erro ao buscar suas coordenadas. Tente novamente.');
    }
  }
}
