import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/controllers/address_edit_controller.dart';
import 'package:vagali/widgets/input.dart';

class AddressEditWidget extends StatelessWidget {
  final AddressEditController controller;

  AddressEditWidget({super.key, required this.controller});

  final FocusNode postalCodeFocus = FocusNode();
  final FocusNode streetFocus = FocusNode();
  final FocusNode numberFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode complementFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    postalCodeFocus.requestFocus();
    return Obx(
      () {

        return ListView(
          children: [
            Obx(() {
              return Input(
                initialValue: controller.postalCodeController.value,
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
              );
            }),
            if (controller.isPostalCodeValid.isTrue &&
                controller.isPostalCodeLoading.isFalse) ...[
              const SizedBox(height: 16),
              Obx(() {
                return Input(
                  initialValue: controller.streetController.value,
                  onChanged: controller.streetController,
                  keyboardType: TextInputType.streetAddress,
                  hintText: 'Rua',
                  error: controller.getError(controller.streetError),
                  currentFocusNode: streetFocus,
                  nextFocusNode: numberFocus,
                );
              }),
              const SizedBox(height: 16),
              Obx(
                () => Input(
                  initialValue: controller.numberController.value,
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
                  initialValue: controller.cityController.value,
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
                  initialValue: controller.stateController.value,
                  onChanged: controller.stateController,
                  hintText: 'Estado',
                  error: controller.getError(controller.stateError),
                  currentFocusNode: stateFocus,
                  nextFocusNode: countryFocus,
                ),
              ),
              const SizedBox(height: 16),
              Input(
                initialValue: controller.countryController.value,
                onChanged: controller.countryController,
                hintText: 'País',
                currentFocusNode: countryFocus,
                nextFocusNode: complementFocus,
              ),
              const SizedBox(height: 16),
              Input(
                initialValue: controller.complementController.value,
                onChanged: controller.complementController,
                hintText: 'Complemento',
                currentFocusNode: complementFocus,
                onSubmit: () => FocusScope.of(context).unfocus(),
              ),
            ],
          ],
        );
      },
    );
  }
}
