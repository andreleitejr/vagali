// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD_XIuXUoGzeMjmyRWcWD_RnSW3hUQYZQU',
    appId: '1:474910118931:web:9e1a9f3eb61941debb9be6',
    messagingSenderId: '474910118931',
    projectId: 'vagali-8385f',
    authDomain: 'vagali-8385f.firebaseapp.com',
    storageBucket: 'vagali-8385f.appspot.com',
    measurementId: 'G-25BTSP9NCF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDS2JyhWQVIgrgDJtOxSz4xocz-dLGqBRE',
    appId: '1:474910118931:android:8c2dbb26b862216bbb9be6',
    messagingSenderId: '474910118931',
    projectId: 'vagali-8385f',
    storageBucket: 'vagali-8385f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQCIRLoMAHX8Zqs1XmQ3ohOVrtza8Rk_s',
    appId: '1:474910118931:ios:6b8338928950d354bb9be6',
    messagingSenderId: '474910118931',
    projectId: 'vagali-8385f',
    storageBucket: 'vagali-8385f.appspot.com',
    androidClientId: '474910118931-jrg7ab4n9cvhk7ev5irt1s3fvesc1dek.apps.googleusercontent.com',
    iosClientId: '474910118931-g8j0dh1gr4kr5bqpakc7docpd5cacp6q.apps.googleusercontent.com',
    iosBundleId: 'com.vagali.vagali',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBQCIRLoMAHX8Zqs1XmQ3ohOVrtza8Rk_s',
    appId: '1:474910118931:ios:2fb8a1c2cd6a3d23bb9be6',
    messagingSenderId: '474910118931',
    projectId: 'vagali-8385f',
    storageBucket: 'vagali-8385f.appspot.com',
    androidClientId: '474910118931-jrg7ab4n9cvhk7ev5irt1s3fvesc1dek.apps.googleusercontent.com',
    iosClientId: '474910118931-ht94kg3r6kqp0ca75guu94uh7adljauf.apps.googleusercontent.com',
    iosBundleId: 'com.vagali.vagali.RunnerTests',
  );
}
