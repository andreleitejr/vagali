import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';

import 'package:vagali/widgets/input.dart';

class StepOneWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepOneWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 56),
            const Text(
              'Informações Gerais',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return Input(
                controller: controller.nameController,
                hintText: 'Nome da Vaga',
                required: true,
                error: controller.nameError.value,
              );
            }),
            const SizedBox(height: 16),
            Obx(
              () => Input(
                controller: controller.descriptionController,
                hintText: 'Descrição da Vaga',
                required: true,
                error: controller.getError(controller.descriptionError),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 16.0),
            AddressCard(address: controller.landlord.address),
          ],
        ),
      ),
    );
  }
}
