import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/views/landlord_edit_view.dart';
import 'package:vagali/features/tenant/views/tenant_edit_view.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/views/code_verification_view.dart';
import 'package:vagali/features/auth/views/location_denied_view.dart';
import 'package:vagali/models/flavor_config.dart';

import 'animation_view.dart';
import 'login_view.dart';

abstract class AuthNavigator {
  void login();

  void verification();

  void register();

  void home();

  void locationDenied();
}

class AuthView extends StatefulWidget {
  final bool isLogOut;

  const AuthView({super.key, this.isLogOut = false});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> implements AuthNavigator {
  late AuthController controller;

  @override
  void initState() {
    controller = Get.put(AuthController(this));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isLogOut) login();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isLogOut ? Container() : AnimationView(),
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
    Get.offAllNamed('/home');

  }

  @override
  void locationDenied() {
    Get.to(() => const LocationDeniedView());
  }
}
