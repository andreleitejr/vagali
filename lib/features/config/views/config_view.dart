import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/auth/views/login_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/views/address_edit_view.dart';
import 'package:vagali/features/user/views/personal_info_edit_view.dart';
import 'package:vagali/features/user/views/user_details_view.dart';
import 'package:vagali/features/user/views/user_edit_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
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
              () => PersonalInfoEditView(user: controller.user),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Endereço',
            onTap: () => Get.to(
              () => AddressEditView(user: controller.user),
            ),
          ),
          divider(),
          ConfigListTile(
            title: 'Termos e Condições',
            onTap: () {},
          ),
          divider(),
          ListTile(
            title: Text(
              'Sair do aplicativo',
              style: ThemeTypography.medium14.apply(
                color: ThemeColors.red,
              ),
            ),
            trailing: Coolicon(
              icon: Coolicons.logOut,
            ),
            onTap: () async {
              await controller.signOut();
              final authController = AuthController();
              Get.offAll(() => LoginView(controller: authController));
            },
          ),
          divider(),
          Expanded(child: Container()),
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
