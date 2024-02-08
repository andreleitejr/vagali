import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/dashboard/views/dashboard_view.dart';
import 'package:vagali/apps/landlord/features/home/controllers/dashboard_controller.dart';
import 'package:vagali/apps/landlord/features/home/views/landlord_home_view.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_edit_view.dart';
import 'package:vagali/apps/landlord/views/landlord_view.dart';
import 'package:vagali/features/calendar/views/calendar_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/avatar.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/shimmer_box.dart';

abstract class HomeNavigator {
  void goToParkingEditPage();
}

class LandlordBaseView extends StatefulWidget {
  final int selectedIndex;

  const LandlordBaseView({super.key, this.selectedIndex = 0});

  @override
  _LandlordBaseViewState createState() => _LandlordBaseViewState();
}

class _LandlordBaseViewState extends State<LandlordBaseView>
    implements HomeNavigator {
  late LandlordHomeController controller;

  @override
  void initState() {
    controller = Get.put(LandlordHomeController(this));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      LandlordHomeView(
        controller: controller,
      ),
      DashboardView(
        reservations: controller.allReservations,
      ),
      CalendarView(
        reservations: controller.allReservations,
      ),
      LandlordView(),
    ];
    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      _buildNavBarItem(Coolicons.house, 'Home'),
      _buildNavBarItem(Coolicons.creditCard, 'Dashboard'),
      _buildNavBarItem(Coolicons.calendar, 'Reservas'),
      _buildNavBarItemWithAvatar(),
    ];
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Coolicon(
          icon: icon,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Coolicon(
          icon: icon,
          color: ThemeColors.primary,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithAvatar() {
    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 38,
        width: 38,
        child: Obx(
          () => ShimmerBox(
            loading: controller.loading.value,
            child: Avatar(image: controller.landlord.image),
          ),
        ),
      ),
      activeIcon: SizedBox(
        height: 38,
        width: 38,
        child: Obx(
          () => ShimmerBox(
            loading: controller.loading.value,
            child: Avatar(
              image: controller.landlord.image,
              isSelected: controller.selectedIndex == 3,
            ),
          ),
        ),
      ),
      label: '',
    );
  }

  @override
  void goToParkingEditPage() {
    Get.to(() => ParkingEditView());
  }
}
