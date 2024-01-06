import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/services/garage_service.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/chip_selector.dart';
import 'package:vagali/widgets/gradient_slider.dart';
import 'package:vagali/widgets/input.dart';

import 'package:vagali/widgets/schedule_input.dart';
import 'package:vagali/widgets/switch_button.dart';

import 'gate_input.dart';

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
              const Expanded(
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
          GradientSlider(
            value: controller.gateHeight,
            min: 2,
            max: 10,
            onChanged: controller.gateHeight,
            label: 'Altura do Portão',
          ),
          GradientSlider(
            value: controller.gateWidth,
            min: 2,
            max: 10,
            onChanged: controller.gateWidth,
            label: 'Largura do Portão',
          ),
          GradientSlider(
            value: controller.garageDepth,
            min: 2,
            max: 20,
            onChanged: controller.garageDepth,
            label: 'Profundidade da Garagem',
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
