import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/controllers/landlord_edit_controller.dart';
import 'package:vagali/features/address/widgets/address_edit_widget.dart';
import 'package:vagali/widgets/input.dart';

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
