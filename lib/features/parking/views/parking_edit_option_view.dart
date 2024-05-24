import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/views/parking_partial_edit_view.dart';
import 'package:vagali/features/parking/widgets/parking_edit_gate.dart';
import 'package:vagali/features/parking/widgets/parking_edit_images.dart';
import 'package:vagali/features/parking/widgets/parking_edit_information.dart';
import 'package:vagali/features/parking/widgets/parking_edit_price.dart';
import 'package:vagali/features/parking/widgets/parking_edit_tags.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';
import 'package:vagali/widgets/snackbar.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';
import 'package:vagali/widgets/warning_dialog.dart';

class ParkingEditOptionView extends StatefulWidget {
  final Parking parking;

  ParkingEditOptionView({super.key, required this.parking});

  @override
  State<ParkingEditOptionView> createState() => _ParkingEditOptionViewState();
}

class _ParkingEditOptionViewState extends State<ParkingEditOptionView> {
  late ParkingEditController controller;

  @override
  void initState() {
    controller = Get.put(ParkingEditController(widget.parking));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(title: widget.parking.name),
      body: Column(
        children: [
          ConfigListTile(
              title: 'Detalhes',
              onTap: () async {
                Get.back();
                Get.to(
                  () => Obx(
                    () => ParkingPartialEditWidget(
                      title: 'Detalhes',
                      body: ParkingEditInformation(controller: controller),
                      onSave: () async {
                        if (controller.isNameValid.isTrue ||
                            controller.isDescriptionValid.isTrue) {
                          _update();
                        }
                      },
                      isValid: controller.isNameValid.value ||
                          controller.isDescriptionValid.value,
                    ),
                  ),
                );
              }),
          divider(),
          ConfigListTile(
            title: 'Fotos',
            onTap: () => Get.to(
              () => Obx(
                () => ParkingPartialEditWidget(
                  title: 'Fotos',
                  body: ParkingEditImages(controller: controller),
                  onSave: () async {
                    if (controller.isImageValid.isTrue) _update();
                  },
                  isValid: controller.isImageValid.value,
                ),
              ),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Portão',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Portão',
                body: ParkingEditGate(controller: controller),
                onSave: () async {
                  if (controller.isGateValid.isTrue) _update();
                },
                isValid: controller.isGateValid.value,
              ),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Tags',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Tags',
                body: ParkingEditTags(controller: controller),
                onSave: () async {
                  if (controller.isTagsValid.isTrue) _update();
                },
                isValid: controller.isTagsValid.value,
              ),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Preços',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Preços',
                body: ParkingEditPrice(controller: controller),
                onSave: () async {
                  if (controller.isPriceValid.isTrue) _update();
                },
                isValid: controller.isPriceValid.value,
              ),
            ),
          ),
          divider(),
          Expanded(child: Container()),
          TextButton(
            onPressed: () => showWarningDialog(context,
                title: 'Deletar a vaga',
                description: 'Tem certeza que gostaria de deletar a vaga?',
                onConfirm: () async {
              await controller.delete();
              Get.back();
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(
                  icon: ThemeIcons.trashEmpty,
                  color: ThemeColors.red,
                ),
                Text(
                  'Excluir vaga',
                  style: ThemeTypography.medium14.apply(
                    color: ThemeColors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget divider() => Divider(
        color: ThemeColors.grey2,
        thickness: 1,
      );

  Future<void> _update() async {
    final result = await controller.updateParking();
    if (result == SaveResult.success) {
      Get.back();
    } else {
      snackBar('Erro', controller.nameError.value);
    }
  }
}
