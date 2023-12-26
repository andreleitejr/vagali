import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/gradient_slider.dart';

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
            'Informações Gerais',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => GradientSlider(
              value: controller.priceController.value,
              min: 8,
              max: 100,
              onChanged: controller.priceController,
              label: 'Valor: R\$${controller.priceController.value.round()}',
            ),
          ),
          Obx(() {
            final suggestedPrices = controller.suggestedPrices;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Preço por 6 horas:',
                        style: ThemeTypography.semiBold16,
                      ),
                    ),
                    Text(
                      '\$${suggestedPrices['6_hours']?.toStringAsFixed(2)}',
                      style: ThemeTypography.semiBold16.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Preço por 12 horas:',
                        style: ThemeTypography.semiBold16,
                      ),
                    ),
                    Text(
                      '\$${suggestedPrices['12_hours']?.toStringAsFixed(2)}',
                      style: ThemeTypography.semiBold16.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Preço por 24 horas:',
                        style: ThemeTypography.semiBold16,
                      ),
                    ),
                    Text(
                      '\$${suggestedPrices['24_hours']?.toStringAsFixed(2)}',
                      style: ThemeTypography.semiBold16.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Preço mensal:',
                        style: ThemeTypography.semiBold16,
                      ),
                    ),
                    Text(
                      '\$${suggestedPrices['monthly']?.toStringAsFixed(2)}',
                      style: ThemeTypography.semiBold16.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
