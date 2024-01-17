import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_edit_view.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/code_verification_view.dart';
import 'package:vagali/features/auth/views/location_denied_view.dart';
import 'package:vagali/features/auth/views/login_error_view.dart';
import 'package:vagali/features/auth/views/select_type_view.dart';
import 'package:vagali/features/home/landlord/views/landlord_base_view.dart';
import 'package:vagali/features/home/tenant//views/base_view.dart';
import 'package:vagali/models/flavor_config.dart';

import 'animation_view.dart';
import 'login_view.dart';

class AuthView extends StatelessWidget {
  final AuthController _controller = Get.put(AuthController());

  AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (_controller.loading.isTrue) {
            return AnimationView();
          }

          final authStatus = _controller.authStatus.value;

          if (authStatus == AuthStatus.unauthenticated) {
            return LoginView(controller: _controller);
          } else if (authStatus == AuthStatus.codeSent ||
              authStatus == AuthStatus.verifying) {
            return CodeVerificationView(controller: _controller);
          } else if (authStatus == AuthStatus.unregistered) {
            return SelectTypeView();
          } else if (authStatus == AuthStatus.authenticated) {
            return Get.find<FlavorConfig>().flavor == Flavor.tenant
                ? const BaseView()
                : LandlordBaseView();
          } else if (authStatus == AuthStatus.parkingNotFound) {
            return const ParkingEditView();
          } else if (authStatus == AuthStatus.locationDenied) {
            return const LocationDeniedView();
          } else {
            return AuthErrorView(
              error: authStatus.name,
            );
          }
        },
      ),
    );
  }
}
