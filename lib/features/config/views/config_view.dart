import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vagali/features/landlord/views/landlord_personal_info_view.dart';
import 'package:vagali/features/tenant/views/tenant_personal_info_view.dart';
import 'package:vagali/features/address/views/address_edit_view.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/legal/terms_and_conditions.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/views/user_delete_view.dart';
import 'package:vagali/models/flavor_config.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ConfigController extends GetxController {
  final User user = Get.find();
  final AuthRepository authRepository = Get.find();

  final packageInfo = Rx<PackageInfo?>(null);

  @override
  Future<void> onInit() async {
    await _initPackageInfo();
    super.onInit();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    packageInfo.value = info;
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}

class ConfigView extends StatelessWidget {
  ConfigView({super.key});

  final controller = Get.put(ConfigController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Configurações',
      ),
      body: Column(
        children: [
          ConfigListTile(
            title: 'Informações pessoais',
            onTap: () => Get.to(
              () => Get.find<FlavorConfig>().flavor == Flavor.tenant
                  ? TenantPersonalInfoView()
                  : LandlordPersonalInfoView(),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Endereço',
            onTap: () => Get.to(
              () => AddressEditView(),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Termos e Condições',
            onTap: () => Get.to(() => TermsAndConditions()),
          ),
          divider(),
          ConfigListTile(
            title: 'Minha conta',
            onTap: () => Get.to(() => UserAccountView()),
          ),
          divider(),
          Expanded(child: Container()),
          ListTile(
            title: Text(
              'Sair do aplicativo',
              style: ThemeTypography.medium14.apply(
                color: ThemeColors.red,
              ),
            ),
            trailing: CustomIcon(
              icon: ThemeIcons.logOut,
            ),
            onTap: () async {
              await controller.signOut();
              controller.dispose();
              Get.offAll(() => AuthView(isLogOut: true));
              // Get.reset();
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              'Versão ${controller.packageInfo.value?.version}',
              style: ThemeTypography.regular12.apply(
                color: ThemeColors.grey3,
              ),
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
}
