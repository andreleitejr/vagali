// import 'package:blurhash/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/config/views/config_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/faq/views/faq_view.dart';
import 'package:vagali/features/tenant/controllers/tenant_controller.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/avatar.dart';
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
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar(
                          image: controller.tenant.image,
                          width: 64,
                          height: 64,
                          isSelected: true,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.tenant.firstName} ${controller.tenant.lastName}',
                              style: ThemeTypography.medium16,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${controller.tenant.address.city}, ${controller.tenant.address.country}',
                              style: ThemeTypography.regular14.apply(
                                color: ThemeColors.grey4,
                              ),
                            ),
                          ],
                        )
                      ],
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
              onTap: () => Get.to(() => FaqView()),
            ),
          ],
        );
      }),
    );
  }
}
