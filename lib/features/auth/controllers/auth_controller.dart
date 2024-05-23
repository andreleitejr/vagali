import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';

// Features
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/item/repositories/item_repository.dart';
import 'package:vagali/features/tenant/repositories/tenant_repository.dart';
import 'package:vagali/models/flavor_config.dart';
import 'package:vagali/utils/extensions.dart';

class AuthController extends GetxController {
  AuthController(this.navigator);

  final AuthNavigator navigator;
  final _authRepository = Get.put(AuthRepository(), permanent: true);
  final _tenantRepository = Get.put(TenantRepository());
  final _landlordRepository = Get.put(LandlordRepository());

  final phone = ''.obs;
  final sms = ''.obs;
  final termsAndConditions = false.obs;
  final minutes = 5.obs;
  final seconds = 0.obs;
  final isCountdownFinished = false.obs;

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
    Get.put(ItemRepository());
    Get.put(ParkingRepository());
    await checkCurrentUser();

    loading(false);
  }

  Future<void> checkCurrentUser() async {
    final isAuthenticated = await _authRepository.isUserAuthenticated();

    await Future.delayed(const Duration(milliseconds: 4700));

    /// TEMPO DA ANIMACAO
    if (isAuthenticated) {
      await _checkAndRedirect();
    } else {
      navigator.login();
      // authStatus.value = AuthStatus.unauthenticated;
    }
  }

  Future<void> _checkAndRedirect() async {
    final isRegisteredInDatabase = await _checkUserInDatabase();
    if (isRegisteredInDatabase) {
      navigator.home();
    } else {
      navigator.register();
    }
  }

  Future<bool> _checkUserInDatabase() async {
    try {
      final user = Get.find<FlavorConfig>().flavor == Flavor.tenant
          ? await _tenantRepository.get(_authRepository.authUser!.uid)
          : await _landlordRepository.get(_authRepository.authUser!.uid);

      if (user != null) {
        Get.put(user, permanent: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendVerificationCode() async {
    try {
      await _authRepository.sendVerificationCode('+55${phone.value}');
      navigator.verification();
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

  Future<void> verifySmsCode() async {
    try {
      authStatus.value = AuthStatus.verifying;

      var newAuthStatus = await _authRepository.verifySmsCode(sms.value);

      if (newAuthStatus == AuthStatus.authenticated) {
        await _checkAndRedirect();
      } else {
        navigator.register();
      }
    } catch (e) {
      error(e.toString());
      authStatus.value = AuthStatus.error;
    }
  }

  RxBool get isValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue && isSmsValid.isTrue)
          .obs;

  RxBool get isLoginValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue).obs;

  RxBool get isPhoneValid {
    final cleanPhone = phone.value.clean.removeParenthesis.removeAllWhitespace;

    return (cleanPhone.length == 11).obs;
  }

  RxBool get isSmsValid => (sms.isNotEmpty && sms.value.length == 6).obs;

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
}
