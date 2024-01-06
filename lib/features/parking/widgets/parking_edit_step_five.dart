import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/reservation/models/reservation_type.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/bottom_sheet.dart';
import 'package:vagali/widgets/gradient_slider.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/input_button.dart';
import 'package:vagali/widgets/price_input.dart';

class StepFiveWidget extends StatelessWidget {
  final ParkingEditController controller;

  StepFiveWidget({super.key, required this.controller});

  final pricePerHourController = TextEditingController();
  final pricePerSixHoursController = TextEditingController();
  final pricePerTwelveHoursController = TextEditingController();
  final pricePerDayController = TextEditingController();
  final pricePerMonthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Obx(
          //   () => InputButton(
          //     controller: controller.reservationTypeController.value,
          //     hintText: 'Qual tipo de reserva?',
          //     onTap: () => _showReservationTypeBottomSheet(context),
          //   ),
          // ),
          // const SizedBox(height: 16),
          Obx(
            () => PriceInput(
              value: controller.pricePerHour.value,
              controller: pricePerHourController,
              hintText: 'Preco por hora',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerHour,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => PriceInput(
              value: controller.pricePerSixHours.value,
              controller: pricePerSixHoursController,
              hintText: 'Preco por 6 horas',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerSixHours,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => PriceInput(
              value: controller.pricePerTwelveHours.value,
              controller: pricePerTwelveHoursController,
              hintText: 'Preco por 12 horas',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerTwelveHours,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => PriceInput(
              value: controller.pricePerDay.value,
              controller: pricePerDayController,
              hintText: 'Preco por diária',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerDay,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return PriceInput(
              value: controller.pricePerMonth.value,
              controller: pricePerMonthController,
              hintText: 'Preco por mês',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerMonth,
            );
          }),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aviso: Os preços são apenas sugestões da plataforma.',
                style: ThemeTypography.regular14.apply(
                  color: ThemeColors.grey4,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showReservationTypeBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet(
        items: reservationTypes
            .map((reservationType) =>
                reservationType.type.toReadableReservationType)
            .toList(),
        title: 'Qual tipo de reserva?',
        onItemSelected: (selectedItem) async {
          controller.reservationTypeController.value = selectedItem;
          focus.unfocus();
        },
      ),
      enableDrag: true,
    );
  }
}
