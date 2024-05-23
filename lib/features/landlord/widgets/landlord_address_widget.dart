import 'package:flutter/material.dart';
import 'package:vagali/features/address/widgets/address_edit_widget.dart';
import 'package:vagali/features/landlord/controllers/landlord_edit_controller.dart';

class LandlordAddressWidget extends StatelessWidget {
  final LandlordEditController controller;

  LandlordAddressWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AddressEditWidget(
      controller: controller.addressController,
    );
  }
}
