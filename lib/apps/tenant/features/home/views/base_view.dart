import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/home/controllers/base_controller.dart';
import 'package:vagali/apps/tenant/features/home/views/home_view.dart';
import 'package:vagali/apps/tenant/views/tenant_view.dart';
import 'package:vagali/features/map/views/map_view.dart';
import 'package:vagali/features/reservation/views/reservation_list_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/avatar.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/shimmer_box.dart';

class BaseView extends StatefulWidget {
  final int selectedIndex;

  const BaseView({super.key, this.selectedIndex = 0});

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  late BaseController controller;

  final List<Widget> _pages = [
    HomeView(),
    MapView(),
    ReservationListView(),
    TenantView(),
  ];

  @override
  void initState() {
    controller = Get.put(BaseController(widget.selectedIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          selectedLabelStyle: ThemeTypography.regular9.apply(
            color: ThemeColors.primary,
          ),
          unselectedLabelStyle: ThemeTypography.regular9.apply(
            color: ThemeColors.grey4,
          ),
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Coolicon(
                  icon: Coolicons.house,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Coolicon(
                  icon: Coolicons.house,
                  color: ThemeColors.primary,
                ),
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon:  Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Coolicon(
                  icon: Coolicons.map,
                ),
              ),
              activeIcon:Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child:  Coolicon(
                  icon: Coolicons.map,
                  color: ThemeColors.primary,
                ),
              ),
              label: 'Mapa',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Coolicon(
                  icon: Coolicons.calendar,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Coolicon(
                  icon: Coolicons.calendar,
                  color: ThemeColors.primary,
                ),
              ),
              label: 'Reservas',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 38,
                width: 38,
                child: Obx(
                  () => ShimmerBox(
                    loading: controller.homeController.loading.value,
                    child: Avatar(image: controller.tenant.image),
                  ),
                ),
              ),
              label: '',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          unselectedItemColor: ThemeColors.grey3,
          selectedItemColor: ThemeColors.primary,
          onTap: controller.selectedIndex,
        ),
      ),
    );
  }
}
