import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Features
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';

class AuthController extends GetxController {
  final _authRepository = Get.put(AuthRepository());
  final _userRepository = Get.put(UserRepository());

  final phoneNumberController = TextEditingController();
  final smsController = TextEditingController();
  final phoneNumberError = RxString('');
  final smsError = RxString('');

  final authStatus = AuthStatus.uninitialized.obs;
  final error = ''.obs;
  final userType = ''.obs;
  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading(true);

    await Future.delayed(const Duration(seconds: 1));

    Get.put(UserRepository());

    await checkCurrentUser();

    phoneNumberController.addListener(() {
      validatePhoneNumber();
    });
    smsController.addListener(() {
      validateSms();
    });
  }

  bool validatePhoneNumber() {
    final isValid = phoneNumberController.text.isNotEmpty;
    phoneNumberError.value = isValid ? '' : 'Insira um telefone válido';
    return isValid;
  }

  bool validateSms() {
    final isValid = smsController.text.isNotEmpty;
    smsError.value = isValid ? '' : 'SMS inválido';
    return isValid;
  }

  Future<void> sendVerificationCode() async {
    try {
      final newAuthStatus = await _authRepository
          .sendVerificationCode('+55${phoneNumberController.text}');
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
      var newAuthStatus =
          await _authRepository.verifySmsCode(smsController.text);

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
