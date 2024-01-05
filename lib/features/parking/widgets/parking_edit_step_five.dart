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

class StepFiveWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepFiveWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          const Text(
            'Informações de Preço',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Obx(
            () => InputButton(
              controller: controller.reservationTypeController.value,
              hintText: 'Qual tipo de reserva?',
              onTap: () => _showReservationTypeBottomSheet(context),
            ),
          ),
          Obx(() {
            if (controller.isFlexible.value) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Obx(
                    () => Input(
                      controller: controller.pricePerHourController.value,
                      hintText: 'Preco por hora',
                      keyboardType: TextInputType.number,
                      error: controller.getError(controller.priceError),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSubmit: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Input(
                      controller: controller.pricePerSixHoursController.value,
                      hintText: 'Preco por 6 horas',
                      keyboardType: TextInputType.number,
                      error: controller.getError(controller.priceError),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSubmit: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Input(
                      controller:
                          controller.pricePerTwelveHoursController.value,
                      hintText: 'Preco por 12 horas',
                      keyboardType: TextInputType.number,
                      error: controller.getError(controller.priceError),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSubmit: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Input(
                      controller: controller.pricePerDayController.value,
                      hintText: 'Preco por diária',
                      keyboardType: TextInputType.number,
                      error: controller.getError(controller.priceError),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSubmit: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
            return Container();
          }),
          Obx(() {
            if (controller.reservationTypeController.value.text.isNotEmpty) {
              return Input(
                controller: controller.pricePerMonthController.value,
                hintText: 'Preco por mês',
                keyboardType: TextInputType.number,
                error: controller.getError(controller.priceError),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onSubmit: () {},
              );
            }
            return Container();
          }),
          // Obx(
          //   () => GradientSlider(
          //     value: controller.priceController,
          //     min: 8,
          //     max: 100,
          //     onChanged: controller.priceController,
          //     label: 'Valor: R\$${controller.priceController.value.round()}',
          //   ),
          // ),
          // Obx(() {
          //   final suggestedPrices = controller.suggestedPrices;
          //   return Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const Expanded(
          //             child: Text(
          //               'Preço por 6 horas:',
          //               style: ThemeTypography.semiBold16,
          //             ),
          //           ),
          //           Text(
          //             '\$${suggestedPrices['6_hours']?.toStringAsFixed(2)}',
          //             style: ThemeTypography.semiBold16.apply(
          //               color: ThemeColors.grey4,
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const Expanded(
          //             child: Text(
          //               'Preço por 12 horas:',
          //               style: ThemeTypography.semiBold16,
          //             ),
          //           ),
          //           Text(
          //             '\$${suggestedPrices['12_hours']?.toStringAsFixed(2)}',
          //             style: ThemeTypography.semiBold16.apply(
          //               color: ThemeColors.grey4,
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const Expanded(
          //             child: Text(
          //               'Preço por 24 horas:',
          //               style: ThemeTypography.semiBold16,
          //             ),
          //           ),
          //           Text(
          //             '\$${suggestedPrices['24_hours']?.toStringAsFixed(2)}',
          //             style: ThemeTypography.semiBold16.apply(
          //               color: ThemeColors.grey4,
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const Expanded(
          //             child: Text(
          //               'Preço mensal:',
          //               style: ThemeTypography.semiBold16,
          //             ),
          //           ),
          //           Text(
          //             '\$${suggestedPrices['monthly']?.toStringAsFixed(2)}',
          //             style: ThemeTypography.semiBold16.apply(
          //               color: ThemeColors.grey4,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   );
          // }),
        ],
      ),
    );
  }

  void _showReservationTypeBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet(
        items: reservationTypes
            .map((reservationType) => reservationType.type.toReadableReservationType)
            .toList(),
        title: 'Qual tipo de reserva?',
        onItemSelected: (selectedItem) async {
          controller.reservationTypeController.value.text = selectedItem;
          focus.unfocus();
        },
      ),
      enableDrag: true,
    );
  }
}
