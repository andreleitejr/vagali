import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/widgets/input.dart';

class AddressEditWidget extends StatelessWidget {
  final UserEditController controller;

  AddressEditWidget({super.key, required this.controller});

  final FocusNode postalCodeFocus = FocusNode();
  final FocusNode streetFocus = FocusNode();
  final FocusNode numberFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode complementFocus = FocusNode();

  // final postalCodeController = TextEditingController();
  // final streetController = TextEditingController();
  // final numberController = TextEditingController();
  // final cityController = TextEditingController();
  // final stateController = TextEditingController();
  // final countryController = TextEditingController();
  // final complementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    postalCodeFocus.requestFocus();
    return ListView(
      children: [
        Obx(
          () => Input(
            onChanged: controller.postalCodeController,
            hintText: 'CEP',
            error: controller.getError(controller.postalCodeError),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            currentFocusNode: postalCodeFocus,
            nextFocusNode: numberFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.streetController,
            keyboardType: TextInputType.streetAddress,
            hintText: 'Rua',
            error: controller.getError(controller.streetError),
            currentFocusNode: streetFocus,
            nextFocusNode: numberFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.numberController,
            hintText: 'Número',
            error: controller.getError(controller.numberError),
            currentFocusNode: numberFocus,
            nextFocusNode: complementFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.cityController,
            hintText: 'Cidade',
            error: controller.getError(controller.cityError),
            currentFocusNode: cityFocus,
            nextFocusNode: stateFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.stateController,
            hintText: 'Estado',
            error: controller.getError(controller.stateError),
            currentFocusNode: stateFocus,
            nextFocusNode: countryFocus,
          ),
        ),
        const SizedBox(height: 16),
        Input(
          onChanged: controller.countryController,
          hintText: 'País',
          currentFocusNode: countryFocus,
          nextFocusNode: complementFocus,
        ),
        const SizedBox(height: 16),
        Input(
          onChanged: controller.complementController,
          hintText: 'Complemento',
          currentFocusNode: complementFocus,
          onSubmit: () => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
