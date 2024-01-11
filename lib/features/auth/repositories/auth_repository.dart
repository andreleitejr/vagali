import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vagali/services/location_service.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticatedAsTenant,
  authenticatedAsLandlord,
  codeSent,
  error,
  unauthenticated,
  verifying,
  unregistered,
  timeout,
  failed,
  parkingNotFound,
  locationDenied,
}

class AuthRepository {
  AuthRepository();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  String _verificationId = "";

  auth.User? authUser;

  bool isUserAuthenticated() {
    authUser = _auth.currentUser;

    if (authUser != null) {
      Get.put<String>(authUser!.phoneNumber!, tag: 'phoneNumber');
      return true;
    }
    return false;
  }

  void updateUserAuthEmail(String email) {
    authUser!.updateEmail(email);
  }

  Future<AuthStatus> _performSignIn(
      Future<auth.UserCredential> Function() signInFunction) async {
    try {
      final userCredential = await signInFunction();
      final user = userCredential.user;

      if (user != null) {
        authUser = user;
        Get.put<String>(user.phoneNumber!, tag: 'phoneNumber');

        return AuthStatus.authenticated;
      } else {
        return AuthStatus.unauthenticated;
      }
    } catch (error) {
      print(
          'Performing sign in error error with function ${signInFunction.toString()}: $error');
      return AuthStatus.failed;
    }
  }

  Future<AuthStatus?> _performSignUp(
      Future<auth.UserCredential> Function() signUpFunction) async {
    try {
      final userCredential = await signUpFunction();
      final user = userCredential.user;

      if (user != null) {
        return AuthStatus.authenticated;
      } else {
        return AuthStatus.unauthenticated;
      }
    } catch (error) {
      print('Error during registration: $error');
      return null;
    }
  }

  Future<AuthStatus?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    Future<auth.UserCredential> emailPasswordSignIn() async {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult;
    }

    return await _performSignIn(emailPasswordSignIn);
  }

  Future<AuthStatus?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    Future<auth.UserCredential> emailPasswordSignUp() async {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult;
    }

    return await _performSignUp(emailPasswordSignUp);
  }

  Future<AuthStatus?> signInWithGoogle() async {
    Future<auth.UserCredential> googleSignIn() async {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final credential = auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
      throw 'Google Sign-In failed';
    }

    return await _performSignIn(googleSignIn);
  }

  Future<AuthStatus?> signInWithFacebook() async {
    Future<auth.UserCredential> facebookSignIn() async {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final auth.OAuthCredential credential =
            auth.FacebookAuthProvider.credential(
          result.accessToken!.token,
        );
        return await _auth.signInWithCredential(credential);
      }
      throw 'Facebook Sign-In failed';
    }

    return await _performSignIn(facebookSignIn);
  }

  Future<AuthStatus?> signInWithApple() async {
    Future<auth.UserCredential> appleSignIn() async {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final credential = auth.OAuthProvider("apple.com").credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );
      return await _auth.signInWithCredential(credential);
    }

    return await _performSignIn(appleSignIn);
  }

  Future<AuthStatus> verifySmsCode(String smsCode) async {
    Future<auth.UserCredential> phoneSignIn() async {
      final auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      return await _auth.signInWithCredential(credential);
    }

    return await _performSignIn(phoneSignIn);
  }

  Future<AuthStatus> sendVerificationCode(
    String phoneNumber,
  ) async {

    try {
      var authStatus = AuthStatus.codeSent;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (auth.AuthCredential authResult) {
          authStatus = AuthStatus.authenticated;
        },
        verificationFailed: (auth.FirebaseAuthException authException) {
          print("Phone verification failed: ${authException.message}");
          authStatus = AuthStatus.failed;
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          _verificationId = verificationId;
          authStatus = AuthStatus.verifying;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          authStatus = AuthStatus.timeout;
        },
        timeout: const Duration(seconds: 60),
      );
      return authStatus;
    } catch (error) {
      print('Error sending verification code: $error');
      // Trate os erros de envio de SMS aqui
      return AuthStatus.failed;
    }
  }

  Future<void> signOut() async => await _auth.signOut();
}
