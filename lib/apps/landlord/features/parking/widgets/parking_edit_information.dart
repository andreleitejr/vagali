import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/widgets/input.dart';

class ParkingEditInformation extends StatelessWidget {
  final ParkingEditController controller;

  ParkingEditInformation({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => Input(
                initialValue: controller.parking.name,
                onChanged: controller.nameController,
                hintText: 'Nome da Vaga',
                required: true,
                error: controller.getError(controller.nameError),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Input(
                initialValue: controller.parking.description,
                onChanged: controller.descriptionController,
                hintText: 'Descrição da Vaga',
                required: true,
                error: controller.getError(controller.descriptionError),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 16.0),
            AddressCard(
              address: controller.parking.address,
              isReservationActive: true,
            ),
          ],
        ),
      ),
    );
  }
}
