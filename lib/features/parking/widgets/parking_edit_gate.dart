import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_slider.dart';
import 'package:vagali/widgets/switch_button.dart';

class ParkingEditGate extends StatelessWidget {
  final ParkingEditController controller;

  const ParkingEditGate({super.key, required this.controller});

  final Color activeBackgroundColor = const Color(0xFF0077B6);
  final Color inactiveBackgroundColor = const Color(0xFFBDBDBD);

  final double minValue = 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'O seu portão é automático?',
                  style: ThemeTypography.semiBold16,
                ),
              ),
              Obx(
                () => SwitchButton(
                  value: controller.isAutomaticController.value,
                  onChanged: controller.isAutomaticController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Obx(() {
            final value = controller.gateHeight.value;
            final valueFormatted = value / 100;

            return GradientSlider(
              title: '${valueFormatted.toStringAsFixed(1)} metros',
              label: 'Altura do Portão',
              tooltip:  '${value.toStringAsFixed(0)} cm',
              value: value < minValue ? minValue : value,
              min: minValue,
              max: 1000,
              onChanged: controller.gateHeight,
            );
          }),
          Obx(() {
            final value = controller.gateWidth.value;
            final valueFormatted = value / 100;

            return GradientSlider(
              title: '${valueFormatted.toStringAsFixed(1)} metros',
              label: 'Largura do Portão',
              tooltip:  '${value.toStringAsFixed(0)} cm',
              value: value < minValue ? minValue : value,
              min: minValue,
              max: 1000,
              onChanged: controller.gateWidth,
            );
          }),
          Obx(() {
            final value = controller.garageDepth.value;
            final valueFormatted = value / 100;

            return GradientSlider(
              title: '${valueFormatted.toStringAsFixed(1)} metros',
              label: 'Profundidade da Garagem',
              tooltip:  '${value.toStringAsFixed(0)} cm',
              value: value < minValue ? minValue : value,
              min: 100,
              max: 8000,
              onChanged: controller.garageDepth,
            );
          }),
          const SizedBox(height: 16),
          const Text(
            'Veículos compativeis:',
            style: ThemeTypography.semiBold16,
          ),
          Obx(
            () => Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: controller.compatibleCarTypes.length,
                itemBuilder: (context, index) {
                  final carType = controller.compatibleCarTypes[index];
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          carType.image,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.compatibleCarTypes[index].title,
                          style: ThemeTypography.semiBold16,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
