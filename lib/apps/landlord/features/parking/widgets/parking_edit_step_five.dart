import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/price_input.dart';

class StepFiveWidget extends StatelessWidget {
  final ParkingEditController controller;

  StepFiveWidget({super.key, required this.controller});

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
          ),
          const SizedBox(height: 16),
          Obx(
            () => PriceInput(
              initialValue:controller.pricePerHourController.value,
              hintText: 'Preco por hora',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerHourController,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () {
              return PriceInput(
                initialValue: controller.pricePerSixHoursController.value,
                hintText: 'Preco por 6 horas',
                keyboardType: TextInputType.number,
                error: controller.getError(controller.priceError),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: controller.pricePerSixHoursController,
                isLoading: controller.isPriceLoading.value,
              );
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () {
              return PriceInput(
                initialValue: controller.pricePerTwelveHoursController.value,
                hintText: 'Preco por 12 horas',
                keyboardType: TextInputType.number,
                error: controller.getError(controller.priceError),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: controller.pricePerTwelveHoursController,
                isLoading: controller.isPriceLoading.value,
              );
            },
          ),
          const SizedBox(height: 16),
          Obx(() {
            return PriceInput(
              initialValue: controller.pricePerDayController.value,
              hintText: 'Preco por diária',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerDayController,
              isLoading: controller.isPriceLoading.value,
            );
          }),
          const SizedBox(height: 16),
          Obx(() {
            return PriceInput(
              initialValue: controller.pricePerMonthController.value,
              hintText: 'Preco por mês',
              keyboardType: TextInputType.number,
              error: controller.getError(controller.priceError),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: controller.pricePerMonthController,
              isLoading: controller.isPriceLoading.value,
            );
          }),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.showErrors.isTrue) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.getError(controller.priceError),
                      style: ThemeTypography.semiBold14
                          .apply(color: ThemeColors.red),
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }

// void _showReservationTypeBottomSheet(BuildContext context) {
//   final focus = FocusScope.of(context);
//
//   Get.bottomSheet(
//     CustomBottomSheet<ReservationType>(
//       items: reservationTypes,
//       title: 'Qual tipo de reserva?',
//       onItemSelected: (selectedItem) async {
//         controller.reservationTypeController.value = selectedItem.title;
//         focus.unfocus();
//       },
//     ),
//     enableDrag: true,
//   );
// }
}
