import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/code_verification_view.dart';
import 'package:vagali/widgets/loading_view.dart';
import 'package:vagali/features/auth/views/location_denied_view.dart';
import 'package:vagali/features/auth/views/login_error_view.dart';
import 'package:vagali/features/auth/views/select_type_view.dart';
import 'package:vagali/features/dashboard/views/dashboard_view.dart';
import 'package:vagali/features/dashboard/views/landlord_base_view.dart';
import 'package:vagali/features/home/views/base_view.dart';
import 'package:vagali/features/home/views/home_view.dart';
import 'package:vagali/features/parking/views/parking_edit_view.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/views/user_edit_view.dart';

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
          final authStatus = _controller.authStatus.value;

          if (authStatus == AuthStatus.unauthenticated) {
            return LoginView(controller: _controller);
          } else if (authStatus == AuthStatus.codeSent) {
            return CodeVerificationView(controller: _controller);
          } else if (authStatus == AuthStatus.verifying) {
            return LoadingView(message: 'Verificando informações de usuário');
          } else if (authStatus == AuthStatus.unregistered) {
            return SelectTypeView();
          } else if (authStatus == AuthStatus.authenticatedAsTenant) {
            return const BaseView();
          } else if (authStatus == AuthStatus.authenticatedAsLandlord) {
            return const LandlordBaseView();
          } else if (authStatus == AuthStatus.parkingNotFound) {
            return const ParkingEditView();
          } else if (authStatus == AuthStatus.locationDenied) {
            return const LocationDeniedView();
          } else if (authStatus == AuthStatus.error) {
            return AuthErrorView();
          } else {
            return AnimationView(controller: _controller);
          }
        },
      ),
    );
  }
}
