import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';

import 'package:vagali/widgets/input.dart';

class StepOneWidget extends StatelessWidget {
  final ParkingEditController controller;

  StepOneWidget({Key? key, required this.controller}) : super(key: key);

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              return Input2(
                controller: nameController,
                value: controller.name.value,
                hintText: 'Nome da Vaga',
                required: true,
                error: controller.getError(controller.nameError),
                onChanged: controller.name,
              );
            }),
            const SizedBox(height: 16),
            Obx(
              () => Input2(
                value: controller.description.value,
                controller: descriptionController,
                hintText: 'Descrição da Vaga',
                required: true,
                error: controller.getError(controller.descriptionError),
                maxLines: 3,
                onChanged: controller.description,
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
