import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/tenant/repositories/tenant_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';
import 'package:vagali/widgets/warning_dialog.dart';

class UserAccountView extends StatelessWidget {
  const UserAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Minha conta',
      ),
      body: Column(
        children: [
          ConfigListTile(
            title: 'Excluir minha conta',
            onTap: () => Get.to(() => UserDeleteView()),
          ),
        ],
      ),
    );
  }
}

class UserDeleteController extends GetxController {
  final User user = Get.find();

  final TenantRepository _tenantRepository = Get.find();
  final LandlordRepository _landlordRepository = Get.find();

  final reason = ''.obs;
  final description = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> delete() async {
    if (user is Tenant) {
      await _tenantRepository.delete(user.id);
    } else {
      await _landlordRepository.delete(user.id);
    }
  }
}

class UserDeleteView extends StatelessWidget {
  UserDeleteView({super.key});

  final controller = Get.put(UserDeleteController());
  final reasonController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Excluir minha conta',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              return Input2(
                value: controller.reason.value,
                controller: reasonController,
                hintText: 'Razão de exclusão',
                onChanged: controller.reason,
              );
            }),
            const SizedBox(height: 16),
            Obx(
              () => Input2(
                value: controller.description.value,
                controller: descriptionController,
                hintText: 'Conte-nos porque está deletando sua conta...',
                maxLines: 5,
                onChanged: controller.description,
              ),
            ),
            Expanded(child: Container()),
            TextButton(
              onPressed: () => showWarningDialog(context,
                  title: 'Tem certeza que deseja excluir sua conta?',
                  description:
                      'Todos os seus dados serão perdidos e não poderão ser recuperados.',
                  onConfirm: () {
                controller.delete();
                controller.dispose();
                Get.offAll(() => AuthView(isLogOut: true));
              }),
              child: Text(
                'Excluir conta',
                style: ThemeTypography.semiBold14.apply(
                  color: ThemeColors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
