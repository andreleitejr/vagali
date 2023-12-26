import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/login_view.dart';
import 'package:vagali/features/home/controllers/base_controller.dart';
import 'package:vagali/features/home/controllers/home_controller.dart';
import 'package:vagali/features/home/views/home_view.dart';
import 'package:vagali/features/map/views/map_view.dart';
import 'package:vagali/features/reservation/views/reservation_list_view.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/tenant/views/tenant_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
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

  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Coolicon(
                icon: Coolicons.house,
              ),
              activeIcon: Coolicon(
                icon: Coolicons.house,
                color: ThemeColors.primary,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Coolicon(
                icon: Coolicons.map,
              ),
              activeIcon: Coolicon(
                icon: Coolicons.map,
                color: ThemeColors.primary,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Coolicon(
                icon: Coolicons.calendar,
              ),
              activeIcon: Coolicon(
                icon: Coolicons.calendar,
                color: ThemeColors.primary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 38,
                width: 38,
                child: Obx(
                  () => ShimmerBox(
                    loading: _controller.loading.value,
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
