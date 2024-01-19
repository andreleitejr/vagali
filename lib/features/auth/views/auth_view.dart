import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_edit_view.dart';
import 'package:vagali/apps/landlord/views/landlord_edit_view.dart';
import 'package:vagali/apps/tenant/views/tenant_edit_view.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/code_verification_view.dart';
import 'package:vagali/features/auth/views/location_denied_view.dart';
import 'package:vagali/features/auth/views/login_error_view.dart';
import 'package:vagali/features/auth/views/select_type_view.dart';
import 'package:vagali/features/home/landlord/views/landlord_base_view.dart';
import 'package:vagali/features/home/tenant//views/base_view.dart';
import 'package:vagali/features/user/views/user_edit_view.dart';
import 'package:vagali/models/flavor_config.dart';

import 'animation_view.dart';
import 'login_view.dart';

abstract class AuthNavigator {
  void login();

  void verification();

  void register();

  void home();

  void locationDenied();

  void createParking();
}

class AuthView extends StatefulWidget {
  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> implements AuthNavigator {
  late AuthController controller;

  @override
  void initState() {
    controller = Get.put(AuthController(this));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (controller.loading.isTrue) {
            return AnimationView();
          }

          final authStatus = controller.authStatus.value;

          return AuthErrorView(
            error: authStatus.name,
          );
        },
      ),
    );
  }

  @override
  void login() {
    Get.to(() => LoginView(controller: controller));
  }

  @override
  void verification() {
    Get.to(() => CodeVerificationView(controller: controller));
  }

  @override
  void register() {
    Get.to(
      () => Get.find<FlavorConfig>().flavor == Flavor.tenant
          ? const TenantEditView()
          : LandlordEditView(),
    );
  }

  @override
  void home() {
    Get.to(() => Get.find<FlavorConfig>().flavor == Flavor.tenant
        ? const BaseView()
        : LandlordBaseView());
  }

  @override
  void createParking() {
    Get.to(() => const ParkingEditView());
  }

  @override
  void locationDenied() {
    Get.to(() => const LocationDeniedView());
  }
}
