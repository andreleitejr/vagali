import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
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
          color: ThemeColors.grey2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Você tem uma nova reserva',
            style: ThemeTypography.semiBold14,
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
          if (controller.currentReservation.value!.isConfirmed) ...[
            FlatButton(
              actionText: _getButtonText(reservation),
              onPressed: () => Get.to(
                () => ChatView(
                  reservation: controller.currentReservation.value!,
                ),
              ),
              backgroundColor: _getButtonColor(reservation),
              icon: _getButtonIcon(reservation),
            ),
          ] else ...[
            FlatButton(
              actionText: _getButtonText(reservation),
              onPressed: () => controller.verifyStatusAndUpdateReservation(),
              backgroundColor: _getButtonColor(reservation),
              icon: _getButtonIcon(reservation),
            ),
          ]
        ],
      ),
    );
  }

  String _getButtonText(Reservation reservation) {
    if (reservation.isPaymentApproved) {
      return 'Confirmar Reserva';
    } else if (reservation.isConfirmed) {
      return 'Conversar com locatário';
    } else {
      return '';
    }
  }

  Color _getButtonColor(Reservation reservation) {
    if (reservation.isConfirmed) {
      return ThemeColors.blue;
    }
    return ThemeColors.primary;
  }

  Widget _getButtonIcon(Reservation reservation) {
    if (reservation.isConfirmed) {
      return Coolicon(
        icon: Coolicons.chat,
        color: Colors.white,
      );
    }
    return Coolicon(
      icon: Coolicons.circleCheck,
      color: Colors.white,
    );
  }
}
