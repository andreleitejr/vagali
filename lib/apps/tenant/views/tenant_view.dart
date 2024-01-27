// import 'package:blurhash/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/controllers/tenant_controller.dart';
import 'package:vagali/apps/tenant/features/vehicle/views/vehicle_list_view.dart';
import 'package:vagali/features/config/views/config_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/views/item_list_view.dart';
import 'package:vagali/features/support/views/support_edit_view.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class TenantView extends StatelessWidget {
  TenantView({super.key});

  final TenantController controller = Get.put(TenantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        showLeading: false,
        title: 'Meu perfil',
      ),
      body: Obx(() {
        if (controller.loading.isTrue) {
          return Loader();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TenantHeader(controller: controller),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.tenant.firstName} ${controller.tenant.lastName}',
                      style: ThemeTypography.medium16,
                    ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   '${controller.tenant.id}',
                    //   style: ThemeTypography.regular12.apply(
                    //     color: ThemeColors.grey3,
                    //   ),
                    // ),
                  ],
                )),
            const SizedBox(height: 16),

            // Obx(
            //   () {
            //     // if (controller.items.isEmpty) {
            //     //   return Container();
            //     // }
            //     final hasVehicle = controller.items
            //         .any((item) => item.type == ItemType.vehicle);
            //     return ConfigListTile(
            //       title: 'Meus ${hasVehicle ? 'veículos e' : ''} objetos',
            //       onTap: () => Get.to(
            //         () => ItemListView(
            //           items: controller.items,
            //         ),
            //       ),
            //     );
            //   },
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
