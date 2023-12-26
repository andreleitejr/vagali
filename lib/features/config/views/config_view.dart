import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/auth/views/login_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ConfigController extends GetxController {
  final AuthRepository authRepository = Get.find();

  final packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  ).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initPackageInfo();
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
            title: 'Meus Dados',
            onTap: () {},
          ),
          Divider(
            color: Color(0xFFE8E8E8),
            thickness: 1,
          ),
          ConfigListTile(
            title: 'Termos e Condições',
            onTap: () {},
          ),
          Divider(
            color: Color(0xFFE8E8E8),
            thickness: 1,
          ),
          ListTile(
            title: Text(
              'Sair do aplicativo',
              style: ThemeTypography.medium14.apply(
                color: ThemeColors.red,
              ),
            ),
            trailing: Coolicon(
              icon: Coolicons.logOut,
              scale: 1.25,
            ),
            onTap: () async {
              await controller.signOut();
              final authController = AuthController();
              Get.offAll(() => LoginView(controller: authController));
            },
          ),
          Expanded(child: Container()),
          Obx(
            () => Text(
              'Versão ${controller.packageInfo.value.version}',
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
}
