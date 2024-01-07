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

  final postalCodeController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final complementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    postalCodeFocus.requestFocus();
    return ListView(
      children: [
        Obx(
          () => Input2(
              controller: postalCodeController,
              value: controller.postalCode.value,
              hintText: 'CEP',
              error: controller.getError(controller.postalCodeError),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CepInputFormatter(),
              ],
              currentFocusNode: postalCodeFocus,
              nextFocusNode: numberFocus,
              onChanged: (text) {
                controller.postalCode(text);
                controller.fetchAddressDetails();
              }),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: streetController,
            value: controller.street.value,
            keyboardType: TextInputType.streetAddress,
            hintText: 'Rua',
            error: controller.getError(controller.streetError),
            currentFocusNode: streetFocus,
            nextFocusNode: numberFocus,
            onChanged: controller.street,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: numberController,
            value: controller.number.value,
            hintText: 'Número',
            error: controller.getError(controller.numberError),
            currentFocusNode: numberFocus,
            nextFocusNode: complementFocus,
            onChanged: controller.number,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: cityController,
            value: controller.city.value,
            hintText: 'Cidade',
            error: controller.getError(controller.cityError),
            currentFocusNode: cityFocus,
            nextFocusNode: stateFocus,
            onChanged: controller.city,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: stateController,
            value: controller.state.value,
            hintText: 'Estado',
            error: controller.getError(controller.stateError),
            currentFocusNode: stateFocus,
            nextFocusNode: countryFocus,
            onChanged: controller.state,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: countryController,
            value: controller.country.value,
            hintText: 'País',
            currentFocusNode: countryFocus,
            nextFocusNode: complementFocus,
            onChanged: controller.country,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: complementController,
            value: controller.complement.value,
            hintText: 'Complemento',
            currentFocusNode: complementFocus,
            onSubmit: () => FocusScope.of(context).unfocus(),
            onChanged: controller.complement,
          ),
        ),
      ],
    );
  }
}
