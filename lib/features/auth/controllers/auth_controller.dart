import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Features
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/utils/extensions.dart';

class AuthController extends GetxController {
  final _authRepository = Get.put(AuthRepository());
  final _userRepository = Get.put(UserRepository());

  final phone = ''.obs;
  final sms = ''.obs;
  final termsAndConditions = false.obs;

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

  //
  // RxString get phoneError =>
  //     (isPhoneValid.isTrue ? '' : 'Insira um telefone válido').obs;
  //
  // RxString get smsError => (isSmsValid.isTrue ? '' : 'SMS inválido').obs;
  //
  // RxString get termsAndConditionsError => (termsAndConditions.isFalse
  //         ? ''
  //         : 'Para utilizar nossa plataforma, é preciso aceitar nossos Termos e Condições.')
  //     .obs;

  final authStatus = AuthStatus.uninitialized.obs;
  final error = ''.obs;
  final userType = ''.obs;
  final loading = false.obs;

  final showErrors = RxBool(false);

  @override
  Future<void> onInit() async {
    super.onInit();

    loading(true);

    await Future.delayed(const Duration(seconds: 1));

    Get.put(UserRepository());

    await checkCurrentUser();
  }


  RxBool get isValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue && isSmsValid.isTrue)
          .obs;


  RxBool get isLoginValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue)
          .obs;

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
    } catch (e) {
      debugPrint('Verification code: $error');
      error(e.toString());
    }
  }

  Future<AuthStatus?> verifySmsCode() async {
    try {
      loading(true);
      authStatus.value = AuthStatus.verifying;

      var newAuthStatus = await _authRepository.verifySmsCode(sms.value);

      if (newAuthStatus == AuthStatus.authenticated) {
        newAuthStatus = await _checkUserInFirestore();
      }

      authStatus.value = newAuthStatus;
      loading(false);

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
      final user = await _userRepository.get(_authRepository.authUser!.uid);

      if (user == null) {
        return AuthStatus.unregistered;
      }

      Get.put(user);
      user.isTenant
          ? Get.put<Tenant>(user as Tenant)
          : Get.put<Landlord>(user as Landlord);

      return user.isTenant
          ? AuthStatus.authenticatedAsTenant
          : AuthStatus.authenticatedAsLandlord;
    } catch (e) {
      return AuthStatus.failed;
    }
  }
}
