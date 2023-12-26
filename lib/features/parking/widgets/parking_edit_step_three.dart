import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/services/garage_service.dart';
import 'package:vagali/widgets/chip_selector.dart';
import 'package:vagali/widgets/gradient_slider.dart';
import 'package:vagali/widgets/input.dart';

import 'package:vagali/widgets/schedule_input.dart';
import 'package:vagali/widgets/switch_button.dart';

import 'gate_input.dart';

class StepThreeWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepThreeWidget({super.key, required this.controller});

  final double minHeight = 1.0;
  final double maxWidth = 10.0;
  final int divisions = 90;

  final Color activeBackgroundColor = const Color(0xFF0077B6);
  final Color inactiveBackgroundColor = const Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          const Text(
            'Informações da vaga',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'O seu portão é automático?',
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
          const SizedBox(height: 16),
          GradientSlider(
            value: controller.gateHeight.value,
            min: minHeight,
            max: maxWidth,
            onChanged: controller.gateHeight,
            label: 'Altura do Portão (m)',
          ),
          GradientSlider(
            value: controller.gateWidth.value,
            min: minHeight,
            max: maxWidth,
            onChanged: controller.gateWidth,
            label: 'Largura do Portão (m)',
          ),
          GradientSlider(
            value: controller.garageDepth.value,
            min: minHeight,
            max: maxWidth,
            onChanged: controller.garageDepth,
            label: 'Profundidade da Garagem (m)',
          ),
          const SizedBox(height: 16),
          const Text(
            'Carros compativeis:',
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
                          carTypeToImageAsset(carType),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          carTypeToString(carType),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildSlider(RxDouble value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: value.value,
          onChanged: (newValue) {
            value(newValue);
          },
          min: minHeight,
          max: maxWidth,
          divisions: divisions,
          label: (value.value > 10.0)
              ? 'Mais que 10 m'
              : '${value.value.toStringAsFixed(2)} m',
        ),
      ],
    );
  }

  String carTypeToString(VehicleTypeEnum carType) {
    switch (carType) {
      case VehicleTypeEnum.hatch:
        return 'Carro Hatch';
      case VehicleTypeEnum.sedan:
        return 'Carro Sedan';
      case VehicleTypeEnum.suv:
        return 'Carro SUV';
      case VehicleTypeEnum.truck:
        return 'Caminhao';
      default:
        return 'Nenhum';
    }
  }

  String carTypeToImageAsset(VehicleTypeEnum carType) {
    switch (carType) {
      case VehicleTypeEnum.hatch:
        return 'images/vehicles/hatch.jpg';
      case VehicleTypeEnum.sedan:
        return 'images/vehicles/sedan.jpg';
      case VehicleTypeEnum.suv:
        return 'images/vehicles/suv.jpg';
      case VehicleTypeEnum.truck:
        return 'images/vehicles/truck.jpg';
      default:
        return 'images/vehicles/hatch.jpg';
    }
  }
}
