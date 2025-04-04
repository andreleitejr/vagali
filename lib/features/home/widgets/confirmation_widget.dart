import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/chat/views/chat_view.dart';
import 'package:vagali/features/home/controllers/dashboard_controller.dart';
import 'package:vagali/features/home/widgets/tracking_location.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/custom_icon.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/title_with_icon.dart';
import 'package:vagali/widgets/user_card.dart';
import 'package:vagali/widgets/warning_dialog.dart';

class ConfirmationWidget extends StatelessWidget {
  final LandlordHomeController controller;

  const ConfirmationWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final reservation = controller.currentReservation.value!;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: controller.currentReservation.value!.isUserOnTheWay ||
                  controller.currentReservation.value!.isInProgress
              ? ThemeColors.primary
              : ThemeColors.grey2,
          width: controller.currentReservation.value!.isUserOnTheWay ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              if (controller.currentReservation.value != null &&
                  (controller.currentReservation.value!.isUserOnTheWay ||
                      controller.currentReservation.value!.isInProgress)) ...[
                PulsatingWidget(),
                const SizedBox(width: 4),
              ],
              Text(
                reservation.status.title,
                style: ThemeTypography.semiBold14,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reservation.status.message,
            style: ThemeTypography.regular12,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomIcon(
                icon: ThemeIcons.clock,
                width: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${reservation.startDate.toFormattedString()}'
                ' até'
                '  ${reservation.endDate.toFormattedString()}',
                style: ThemeTypography.regular12,
              ),
            ],
          ),
          const SizedBox(height: 24),
          UserCard(
            user: reservation.tenant as User,
            message: reservation.reservationMessage,
          ),
          const SizedBox(height: 16),
          // VehicleInfoWidget(vehicle: reservation.item!),
          const SizedBox(height: 16),
          Row(
            children: [
              const CustomIcon(
                icon: ThemeIcons.creditCard,
                width: 18,
                color: Colors.black,
              ),
              const SizedBox(width: 4),
              Text(
                'Você receberá R\$${reservation.totalCost.toStringAsFixed(2)} pela reserva',
                style: ThemeTypography.regular14,
              ),
            ],
          ),
          const SizedBox(height: 8),

          const Divider(
            color: ThemeColors.grey2,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          TitleWithIcon(
            title: 'O que você precisa guardar',
            icon: ThemeIcons.circleCheckOutline,
          ),
          const SizedBox(height: 8),
          Text(
            itemTypes
                .firstWhere((item) => item.type == reservation.item!.type)
                .name!,
          ),
          const SizedBox(height: 16),

          /// JUNTAR COM O RESERVATION DETAILS VIEW
          ..._buildButtonsBasedOnStatus(reservation),
          if (reservation.isPaymentApproved) ...[
            _buildFlatButton(
              'Cancelar',
              () => showWarningDialog(
                context,
                title: 'Cancelar reserva',
                description: 'Tem certeza que gostaria de cancelar a reserva?',
                onConfirm: () =>
                    controller.updateReservation(ReservationStatus.canceled),
              ),
              ThemeColors.red,
            ),
          ]
        ],
      ),
    );
  }

  List<Widget> _buildButtonsBasedOnStatus(Reservation reservation) {
    List<Widget> buttons = [];

    if (reservation.isPaymentApproved) {
      buttons.add(
        _buildFlatButton(
          'Aceitar',
          () {
            controller.updateReservation(ReservationStatus.confirmed);
          },
          ThemeColors.primary,
        ),
      );
    }

    if ((reservation.isInProgress || reservation.isParked) && !reservation.isPaymentApproved) {
      buttons.add(
        _buildFlatButton(
          'Concluir reserva',
          () {
            controller.updateReservation(ReservationStatus.concluded);
          },
          ThemeColors.primary,
        ),
      );
    }

    if (reservation.isUserOnTheWay || reservation.isArrived) {
      buttons.add(
        _buildFlatButton(
          'Acompanhar veículo',
          () => Get.to(
            () => TrackingLocation(controller: controller),
          ),
          ThemeColors.primary,
        ),
      );
      buttons.add(
        _buildFlatButton(
          'Confirmar estacionamento',
              () {
            controller.updateReservation(ReservationStatus.parked);
          },
          ThemeColors.secondary,
        ),
      );
    }

    if (reservation.isArrived) {
      buttons.add(
        _buildFlatButton(
          'Confirmar estacionamento',
          () => Get.to(
            () => TrackingLocation(controller: controller),
          ),
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

    // if (reservation.isConcluded) {
    //   buttons.add(_buildFlatButton(
    //     'Avaliar locatário',
    //     () {},
    //     ThemeColors.blue,
    //   ));
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
}

class PulsatingWidget extends StatefulWidget {
  @override
  _PulsatingWidgetState createState() => _PulsatingWidgetState();
}

class _PulsatingWidgetState extends State<PulsatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColors.primary,
            ),
          ),
        );
      },
    );
  }
}
