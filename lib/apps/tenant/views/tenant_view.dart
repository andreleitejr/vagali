// import 'package:blurhash/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/controllers/tenant_controller.dart';
import 'package:vagali/apps/tenant/features/vehicle/views/vehicle_list_view.dart';
import 'package:vagali/features/config/views/config_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/support/views/support_edit_view.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loader.dart';

class TenantView extends StatelessWidget {
  TenantView({super.key});

  final TenantController controller = Get.put(TenantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.loading.isTrue) {
          return Loader();
        }
        return Column(
          children: [
            // TenantHeader(controller: controller),
            const SizedBox(height: 16),
            Text(
              controller.tenant.firstName,
              style: ThemeTypography.medium16,
            ),
            const SizedBox(height: 16),

            // ConfigListTile(
            //   title: 'Meus Veículos',
            //   onTap: () => Get.to(() => VehicleListView()),
            // ),
            const Divider(
              color: ThemeColors.grey2,
              thickness: 1,
            ),
            ConfigListTile(
              title: 'Configurações',
              onTap: () => Get.to(() => ConfigView()),
            ),
            const Divider(
              color: ThemeColors.grey2,
              thickness: 1,
            ),
            ConfigListTile(
              title: 'Ajuda',
              onTap: () => Get.to(() => SupportEditView()),
            ),
          ],
        );
      }),
    );
  }
}
