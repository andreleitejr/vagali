import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
import 'package:vagali/features/home/landlord/widgets/tracking_location.dart';
import 'package:vagali/features/message/views/message_view.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/widgets/vehicle_info_widget.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/user_card.dart';

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
          color: controller.currentReservation.value!.isUserOnTheWay
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
                  controller.currentReservation.value!.isUserOnTheWay) ...[
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
              Coolicon(
                icon: Coolicons.clock,
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
          VehicleInfoWidget(vehicle: reservation.vehicle!),
          const SizedBox(height: 16),
          Row(
            children: [
              const Coolicon(
                icon: Coolicons.creditCard,
                width: 18,
              ),
              const SizedBox(width: 4),
              Text(
                'Você receberá R\$${reservation.totalCost.toStringAsFixed(2)} pela reserva',
                style: ThemeTypography.regular14.apply(
                  color: ThemeColors.grey4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildButtonsBasedOnStatus(reservation),
        ],
      ),
    );
  }

  List<Widget> _buildButtonsBasedOnStatus(Reservation reservation) {
    List<Widget> buttons = [];

    if (reservation.isConfirmed) {
      buttons.add(
        _buildFlatButton(
          'Estou à caminho',
          controller.verifyStatusAndUpdateReservation,
          ThemeColors.primary,
        ),
      );
    }

    if (reservation.isUserOnTheWay) {
      buttons.add(
        _buildFlatButton(
          'Acompanhar veículo',
          () => Get.to(
            () => TrackingLocation(controller: controller),
          ),
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
