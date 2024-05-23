import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/controllers/base_controller.dart';
import 'package:vagali/features/home/views/home_view.dart';
import 'package:vagali/features/map/views/map_view.dart';
import 'package:vagali/features/reservation/views/reservation_list_view.dart';
import 'package:vagali/features/tenant/views/tenant_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/avatar.dart';
import 'package:vagali/widgets/custom_icon.dart';
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
    controller = Get.put(BaseController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedIndex(widget.selectedIndex);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar:Obx(
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
          items: _buildBottomNavBarItems(),
          currentIndex: controller.selectedIndex.value,
          unselectedItemColor: ThemeColors.grey3,
          selectedItemColor: ThemeColors.primary,
          onTap: controller.selectedIndex,
        ),
      ),
    );
  }


  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      _buildNavBarItem(ThemeIcons.house, 'Home'),
      _buildNavBarItem(ThemeIcons.map, 'Mapa'),
      _buildNavBarItem(ThemeIcons.calendar, 'Reservas'),
      _buildNavBarItemWithAvatar(),
    ];
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: CustomIcon(
          icon: icon,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: CustomIcon(
          icon: icon,
          color: ThemeColors.primary,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithAvatar() {
    return BottomNavigationBarItem(
      icon: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 38,
        width: 38,
        child: Obx(
              () => ShimmerBox(
            loading: controller.homeController.loading.value,
            child: Avatar(image: controller.tenant.image),
          ),
        ),
      ),
      activeIcon: Container(

        margin: const EdgeInsets.only(top: 8),
        height: 38,
        width: 38,
        child: Obx(
              () => ShimmerBox(
            loading: controller.homeController.loading.value,
            child: Avatar(
              image: controller.tenant.image,
              isSelected: controller.selectedIndex == 3,
            ),
          ),
        ),
      ),
      label: '',
    );
  }
}
