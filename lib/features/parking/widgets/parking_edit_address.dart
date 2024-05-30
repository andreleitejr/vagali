import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/widgets/address_edit_widget.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingEditAddress extends StatelessWidget {
  final ParkingEditController controller;

  ParkingEditAddress({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        // showLeading: false,
        title: 'Editar Endereço',
        actions: [
          Obx(
            () => TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Salvar',
                style: ThemeTypography.semiBold14.apply(
                  color: controller.addressController.isAddressValid.isTrue
                      ? ThemeColors.primary
                      : ThemeColors.grey3,
                ),
              ),
            ),
          ),
        ],
      ),
      body: AddressEditWidget(
        controller: controller.addressController,
      ),
    );
  }
}
