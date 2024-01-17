import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/apps/landlord/repositories/landlord_repository.dart';
import 'package:vagali/apps/tenant/features/home/models/tenant.dart';
import 'package:vagali/apps/tenant/features/home/repositories/tenant_repository.dart';

// Features
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/models/flavor_config.dart';
import 'package:vagali/utils/extensions.dart';

class AuthController extends GetxController {
  final _authRepository = Get.put(AuthRepository());
  final _tenantRepository = Get.put(TenantRepository());
  final _landlordRepository = Get.put(LandlordRepository());

  final phone = ''.obs;
  final sms = ''.obs;
  final termsAndConditions = false.obs;
  var minutes = 5.obs;
  var seconds = 0.obs;
  var isCountdownFinished = false.obs;

  String get inputError {
    if (isPhoneValid.isFalse) {
      return 'Insira um telefone válido';
    } else if (termsAndConditions.isFalse) {
      return 'Para utilizar nossa plataforma, é preciso aceitar nossos Termos e Condições.';
    } else if (isSmsValid.isFalse) {
      return 'SMS inválido';
    } else {
      return 'Algum campo necessita de atenção';
    }
  }

  final authStatus = AuthStatus.uninitialized.obs;
  final error = ''.obs;
  final userType = ''.obs;
  final loading = false.obs;

  final showErrors = RxBool(false);

  @override
  Future<void> onInit() async {
    super.onInit();

    loading(true);
    FlutterNativeSplash.remove();

    await checkCurrentUser();

    await Future.delayed(const Duration(milliseconds: 2800));
    loading(false);
  }

  RxBool get isValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue && isSmsValid.isTrue)
          .obs;

  RxBool get isLoginValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue).obs;

  RxBool get isPhoneValid {
    final cleanPhone = phone.value.clean.removeParenthesis.removeAllWhitespace;

    print('${cleanPhone.length == 11}');
    return (cleanPhone.length == 11).obs;
  }

  RxBool get isSmsValid => (sms.isNotEmpty && sms.value.length == 6).obs;

  Future<void> sendVerificationCode() async {
    try {
      final newAuthStatus =
          await _authRepository.sendVerificationCode('+55${phone.value}');
      authStatus.value = newAuthStatus;
      startCountdown();
    } catch (e) {
      debugPrint('Verification code: $error');
      error(e.toString());
    }
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();

        isCountdownFinished.value = true;
      } else {
        if (seconds.value == 0) {
          minutes.value--;
          seconds.value = 59;
        } else {
          seconds.value--;
        }
      }
    });
  }

  Future<AuthStatus?> verifySmsCode() async {
    try {
      authStatus.value = AuthStatus.verifying;

      var newAuthStatus = await _authRepository.verifySmsCode(sms.value);

      if (newAuthStatus == AuthStatus.authenticated) {
        newAuthStatus = await _checkUserInFirestore();
      }

      authStatus.value = newAuthStatus;

      return authStatus.value;
    } catch (e) {
      error(e.toString());

      authStatus.value = AuthStatus.error;
      return null;
    }
  }

  Future<void> checkCurrentUser() async {
    final isAuthenticated = _authRepository.isUserAuthenticated();

    if (isAuthenticated) {
      final newAuthStatus = await _checkUserInFirestore();
      authStatus.value = newAuthStatus;
    } else {
      authStatus.value = AuthStatus.unauthenticated;
    }
  }

  Future<AuthStatus> _checkUserInFirestore() async {
    try {
      final user = Get.find<FlavorConfig>().flavor == Flavor.tenant
          ? await _tenantRepository.get(_authRepository.authUser!.uid)
          : await _landlordRepository.get(_authRepository.authUser!.uid);

      if (user == null) {
        return AuthStatus.unregistered;
      }

      Get.put(user);

      return AuthStatus.authenticated;
    } catch (e) {
      return AuthStatus.failed;
    }
  }
}
