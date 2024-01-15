import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/views/parking_partial_edit_view.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_five.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_four.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_one.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_three.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_two.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingEditOptionView extends StatelessWidget {
  final controller = Get.put(ParkingEditController());

  ParkingEditOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(title: 'Configurações'),
      body: Column(
        children: [
          ConfigListTile(
            title: 'Detalhes',
            onTap: () => Get.to(
              () => Obx(() {
                print(
                    'HEHUSAHUDSHADUHASDSADUASDHUD TESTANDO2 ${controller.nameController.value} ${(controller.isNameValid.isTrue && controller.isDescriptionValid.isTrue).obs.value}');
                return ParkingPartialEditWidget(
                  title: 'Detalhes',
                  body: StepOneWidget(controller: controller),
                  onSave: () => controller.save(),
                  isValid: (controller.isNameValid.isTrue &&
                          controller.isDescriptionValid.isTrue)
                      .obs,
                );
              }),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Fotos',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Fotos',
                body: StepTwoWidget(controller: controller),
                onSave: () => controller.save(),
                isValid: controller.isImageValid,
              ),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Portão',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Portão',
                body: StepThreeWidget(controller: controller),
                onSave: () => controller.save(),
                isValid: controller.isGateValid,
              ),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Tags',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Tags',
                body: StepFourWidget(controller: controller),
                onSave: () => controller.save(),
                isValid: controller.isTagsValid,
              ),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Preços',
            onTap: () => Get.to(
              () => ParkingPartialEditWidget(
                title: 'Preços',
                body: Obx(
                  () => StepFiveWidget(
                    controller: controller,
                  ),
                ),
                onSave: () => controller.save(),
                isValid: controller.isPriceValid,
              ),
            ),
          ),
          divider(),
        ],
      ),
    );
  }

  Widget divider() => Divider(
        color: ThemeColors.grey2,
        thickness: 1,
      );
}
