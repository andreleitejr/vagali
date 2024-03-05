import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:vagali/app.dart';
import 'package:vagali/models/flavor_config.dart';
import 'firebase_options.dart';

final kApiUrl = defaultTargetPlatform == TargetPlatform.android
    ? 'http://192.168.0.75:53152'
    : 'http://localhost:4242';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(FlavorConfig(flavor: Flavor.tenant));

  Stripe.publishableKey =
      'pk_test_51OgmanAXTbv1IFTHTPfKEjPi4diT4rJkC3mIoIctRS1H1VNXEl8d0xf5GdNBUGDtLXR9UKugHg5MSI1YBpKB23HC00zxofvXM1';

  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';

  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await dotenv.load(fileName: "assets/.env");
  runApp(const App());
}
