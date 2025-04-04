import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/widgets/parking_edit_address.dart';
import 'package:vagali/widgets/input.dart';

class ParkingEditInformation extends StatelessWidget {
  final ParkingEditController controller;

  ParkingEditInformation({Key? key, required this.controller})
      : super(key: key);

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
                initialValue: controller.parking?.name,
                onChanged: controller.name,
                hintText: 'Nome da Vaga',
                required: true,
                error: controller.getError(controller.nameError),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Input(
                initialValue: controller.parking?.description,
                onChanged: controller.description,
                hintText: 'Descrição da Vaga',
                required: true,
                error: controller.getError(controller.descriptionError),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              final address = controller.addressController.isAddressValid.isTrue
                  ? controller.addressController.address.value
                  : controller.landlord.address;

              return AddressCard(
                address: address,
                isReservationActive: true,
                editModeOn: true,
                onEditPressed: () async {
                  await Get.to(
                      () => ParkingEditAddress(controller: controller));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
