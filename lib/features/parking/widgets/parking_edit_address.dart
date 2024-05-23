import 'package:flutter/material.dart';
import 'package:vagali/features/address/widgets/address_edit_widget.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';

class ParkingEditAddress extends StatelessWidget {
  final ParkingEditController controller;

  ParkingEditAddress({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AddressEditWidget(
      controller: controller.addressController,
    );
  }
}
