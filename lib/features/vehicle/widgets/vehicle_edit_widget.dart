import 'dart:ffi';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/models/states.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/controllers/vehicle_edit_controller.dart';
import 'package:vagali/features/vehicle/models/vehicle_color.dart';
import 'package:vagali/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/bottom_sheet.dart';
import 'package:vagali/widgets/image_button.dart';
import 'package:vagali/widgets/image_picker_bottom_sheet.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/input_button.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';

class VehicleEditWidget extends StatelessWidget {
  final VehicleEditController controller;
  final bool allowToSkip;

  VehicleEditWidget({
    super.key,
    required this.controller,
    this.allowToSkip = false,
  });

  final FocusNode typeFocus = FocusNode();
  final FocusNode licensePlateFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();
  final FocusNode colorFocus = FocusNode();
  final FocusNode brandFocus = FocusNode();
  final FocusNode modelFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return ListView(
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageButton(
                imageUrl: controller.imageFileController.value?.path,
                imageSize: 100.0,
                imageDataSource: ImageDataSource.asset,
                onPressed: () async {
                  final source = await showImagePickerBottomSheet(context);

                  if (source != null) {
                    await controller.pickImage(source);

                    await Future.delayed(const Duration(milliseconds: 500));
                    _showVehicleTypeBottomSheet(context);
                  }
                },
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.imageBlurhash.value  != null) {
            return Container();
          }
          return Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Tire uma foto',
                style: ThemeTypography.regular14.apply(
                  color: ThemeColors.grey4,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () => InputButton(
            onChanged: controller.vehicleTypeController,
            hintText: 'Tipo de veículo',
            error: controller.getError(controller.vehicleTypeError),
            onTap: () => _showVehicleTypeBottomSheet(context),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.licensePlateController,
            hintText: 'Placa do Veículo',
            error: controller.getError(controller.licensePlateError),
            inputFormatters: [
              PlacaVeiculoInputFormatter(),
            ],
            currentFocusNode: licensePlateFocus,
            nextFocusNode: brandFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.brandController,
            hintText: 'Marca do Veículo',
            error: controller.getError(controller.brandError),
            currentFocusNode: brandFocus,
            nextFocusNode: modelFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.modelController,
            hintText: 'Modelo do Veículo',
            error: controller.getError(controller.modelError),
            currentFocusNode: modelFocus,
            nextFocusNode: yearFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.yearController,
            hintText: 'Ano do Veículo',
            error: controller.getError(controller.yearError),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            currentFocusNode: yearFocus,
            onSubmit: () {
              yearFocus.unfocus();
              _showColorBottomSheet(context);
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => GestureDetector(
            onTap: () => _showColorBottomSheet(context),
            child: Input(
              enabled: false,
              onChanged: controller.colorController,
              hintText: 'Cor do Veículo',
              error: controller.getError(controller.colorError),
              currentFocusNode: colorFocus,
              nextFocusNode: stateFocus,
              onSubmit: () {
                stateFocus.unfocus();
                _showStateBottomSheet(context);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => GestureDetector(
            onTap: () => _showStateBottomSheet(context),
            child: Input(
              enabled: false,
              onChanged: controller.registrationStateController,
              hintText: 'Estado de Registro',
              error: controller.getError(controller.registrationStateError),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => RoundedGradientButton(
            onPressed: () async {
              final isSuccess = await controller.save();
              if (isSuccess) {
                Get.toNamed('/base');
              } else {
                Get.snackbar('Erro', 'Houve um erro ao salvar o veiculo');
              }
            },
            actionText: 'Criar veículo',
            loading: controller.loading.value,
          ),
        ),
        const SizedBox(height: 16),
        if (allowToSkip)
          TextButton(
            onPressed: () async {
              Get.toNamed('/base');
            },
            child: const Text('Pular'),
          ),
      ],
    );
  }

  void _showVehicleTypeBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);
    Get.bottomSheet(
      CustomBottomSheet(
        items: vehicleTypes.map((vehicle) => vehicle.title).toList(),
        title: "Selecione o tipo de veículo",
        onItemSelected: (selectedItem) {
          controller.vehicleTypeController.value = selectedItem;
          focus.requestFocus(licensePlateFocus);
        },
      ),
      enableDrag: true,
    );
  }

  void _showStateBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);
    Get.bottomSheet(
      CustomBottomSheet(
        items: statesList
            .map((state) => '${state.title} - ${state.acronym}')
            .toList(),
        title: "Selecione o estado de registro",
        onItemSelected: (selectedItem) {
          controller.registrationStateController.value = selectedItem;
          focus.unfocus();
        },
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  void _showColorBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);
    Get.bottomSheet(
      Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Selecione a cor do veiculo',
              style: ThemeTypography.medium16.apply(
                color: ThemeColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: vehicleColorsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      controller.colorController.value =
                          vehicleColorsList[index].title;
                      Get.back();
                      _showStateBottomSheet(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(int.parse(
                                  vehicleColorsList[index]
                                      .hexCode
                                      .substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                          border: vehicleColorsList[index].title == 'Branco'
                              ? Border.all(color: ThemeColors.grey3)
                              : null,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }
}
