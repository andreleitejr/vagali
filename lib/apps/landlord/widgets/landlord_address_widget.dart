import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/controllers/landlord_edit_controller.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/widgets/input.dart';

class LandlordAddressWidget extends StatelessWidget {
  final LandlordEditController controller;

  LandlordAddressWidget({super.key, required this.controller});

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
        if (controller.loading.isTrue) {
          return Container();
        }
        return ListView(
          children: [
            Obx(() {
              return Input(
                initialValue:
                    controller.addressController.postalCodeController.value,
                onChanged: controller.addressController.postalCodeController,
                hintText: 'CEP',
                error: controller
                    .getError(controller.addressController.postalCodeError),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(),
                ],
                currentFocusNode: postalCodeFocus,
                nextFocusNode: numberFocus,
              );
            }),
            if (controller.addressController.isPostalCodeValid.isTrue &&
                controller.addressController.isPostalCodeLoading.isFalse) ...[
              const SizedBox(height: 16),
              Obx(() {
                return Input(
                  initialValue:
                      controller.addressController.streetController.value,
                  onChanged: controller.addressController.streetController,
                  keyboardType: TextInputType.streetAddress,
                  hintText: 'Rua',
                  error: controller
                      .getError(controller.addressController.streetError),
                  currentFocusNode: streetFocus,
                  nextFocusNode: numberFocus,
                );
              }),
              const SizedBox(height: 16),
              Obx(
                () => Input(
                  initialValue:
                      controller.addressController.numberController.value,
                  onChanged: controller.addressController.numberController,
                  hintText: 'Número',
                  error: controller
                      .getError(controller.addressController.numberError),
                  currentFocusNode: numberFocus,
                  nextFocusNode: complementFocus,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Input(
                  initialValue:
                      controller.addressController.cityController.value,
                  onChanged: controller.addressController.cityController,
                  hintText: 'Cidade',
                  error: controller
                      .getError(controller.addressController.cityError),
                  currentFocusNode: cityFocus,
                  nextFocusNode: stateFocus,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Input(
                  initialValue:
                      controller.addressController.stateController.value,
                  onChanged: controller.addressController.stateController,
                  hintText: 'Estado',
                  error: controller
                      .getError(controller.addressController.stateError),
                  currentFocusNode: stateFocus,
                  nextFocusNode: countryFocus,
                ),
              ),
              const SizedBox(height: 16),
              Input(
                initialValue:
                    controller.addressController.countryController.value,
                onChanged: controller.addressController.countryController,
                hintText: 'País',
                currentFocusNode: countryFocus,
                nextFocusNode: complementFocus,
              ),
              const SizedBox(height: 16),
              Input(
                initialValue:
                    controller.addressController.complementController.value,
                onChanged: controller.addressController.complementController,
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
