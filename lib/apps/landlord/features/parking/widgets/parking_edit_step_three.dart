import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_slider.dart';
import 'package:vagali/widgets/switch_button.dart';

class StepThreeWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepThreeWidget({super.key, required this.controller});

  final Color activeBackgroundColor = const Color(0xFF0077B6);
  final Color inactiveBackgroundColor = const Color(0xFFBDBDBD);

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
                  'O seu portão é automático? ${controller.garageDepth.value}',
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
          Obx(
            () => GradientSlider(
              value: controller.gateHeight.value < 1 ? 1 : controller.gateHeight.value,
              min: 1,
              max: 100,
              onChanged: controller.gateHeight,
              label: 'Altura do Portão',
            ),
          ),
          Obx(
            () => GradientSlider(
              value: controller.gateWidth.value < 1 ? 1 : controller.gateWidth.value,
              min: 1,
              max: 100,
              onChanged: controller.gateWidth,
              label: 'Largura do Portão',
            ),
          ),
          Obx(
            () => GradientSlider(
              value: controller.garageDepth.value < 1 ? 1 : controller.garageDepth.value,
              min: 1,
              max: 200,
              onChanged: controller.garageDepth,
              label: 'Profundidade da Garagem',
            ),
          ),
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
