import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/config/views/config_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/landlord/controllers/landlord_controller.dart';
import 'package:vagali/features/landlord/widgets/landlord_header.dart';
import 'package:vagali/features/parking/views/parking_list_view.dart';
import 'package:vagali/features/support/views/support_edit_view.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loader.dart';

class LandlordView extends StatelessWidget {
  LandlordView({super.key});

  final controller = Get.put(LandlordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.loading.isTrue) {
          return Loader();
        }
        return Column(
          children: [
            LandlordHeader(controller: controller),
            const SizedBox(height: 16),
            Text(
              controller.landlord.firstName,
              style: ThemeTypography.medium16,
            ),
            const SizedBox(height: 16),
            ConfigListTile(
              title: 'Minhas vagas',
              onTap: () => Get.to(
                () => ParkingListView(),
              ),
            ),
            const Divider(
              color: ThemeColors.grey2,
              thickness: 1,
            ),
            ConfigListTile(
              title: 'Configurações',
              onTap: () => Get.to(
                () => ConfigView(),
              ),
            ),
            const Divider(
              color: ThemeColors.grey2,
              thickness: 1,
            ),
            ConfigListTile(
              title: 'Ajuda',
              onTap: () => Get.to(
                () => SupportEditView(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
