import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
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

  const ConfirmationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final reservation = controller.currentLandlordReservation.value!;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ThemeColors.grey2,
          )),
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
            user: controller.tenant.value as User,
            message: reservation.reservationMessage,
          ),
          const SizedBox(height: 16),
          VehicleInfoWidget(vehicle: controller.vehicle.value!),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Você receberá R\$${reservation.totalCost.toStringAsFixed(0)} pela reserva',
                style: ThemeTypography.medium16,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // const Text('Localização do Usuário:'),
          // if (reservation.locationHistory.isNotEmpty)
          //   _buildLocationHistoryList(reservation.locationHistory),
          if (reservation.isPaymentApproved) ...[
            FlatButton(
              actionText: _getButtonText(reservation),
              onPressed: () => controller.verifyStatusAndUpdateReservation(),
              backgroundColor: _getButtonColor(reservation),
              icon: _getButtonIcon(reservation),
            ),
          ] else if (reservation.isConfirmed) ...[
            FlatButton(
              actionText: _getButtonText(reservation),
              onPressed: () => controller.verifyStatusAndUpdateReservation(),
              backgroundColor: _getButtonColor(reservation),
              icon: _getButtonIcon(reservation),
            ),
          ],
          const SizedBox(height: 8),
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
      return const Icon(
        Icons.chat_bubble_outline,
        color: Colors.white,
        size: 20,
      );
    }
    return const Icon(
      Icons.add_circle_outline,
      color: Colors.white,
      size: 20,
    );
  }
}
