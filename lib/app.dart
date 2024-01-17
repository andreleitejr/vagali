import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_edit_view.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/auth/views/select_type_view.dart';
import 'package:vagali/features/home/landlord/views/landlord_base_view.dart';
import 'package:vagali/features/home/tenant/views/base_view.dart';
import 'package:vagali/models/flavor_config.dart';
import 'package:vagali/theme/theme_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'Vagali',
      theme: ThemeData(
        primaryColor: ThemeColors.primary,
        // primarySwatch: ThemeColors.primary,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ThemeColors.primary,
          ),
        ),
      ),
      initialRoute: '/auth',
      getPages: Get.find<FlavorConfig>().flavor == Flavor.tenant
          ? tenantPages()
          : landlordPages(),
    );
  }

  List<GetPage<dynamic>> tenantPages() {
    return [
      GetPage(
        name: '/auth',
        page: () => AuthView(),
      ),
      GetPage(
        name: '/home',
        page: () => const LandlordBaseView(),
      ),
    ];
  }

  List<GetPage<dynamic>> landlordPages() {
    return [
      GetPage(
        name: '/auth',
        page: () => AuthView(),
      ),
      GetPage(
        name: '/home',
        page: () => const BaseView(),
      ),
    ];
  }
}
