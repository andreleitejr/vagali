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
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
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
                icon: Coolicons.creditCard,
              ),
              activeIcon: Coolicon(
                icon: Coolicons.creditCard,
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
                    loading: controller.loading.value,
                    child: Avatar(image: controller.landlord.image),
                  ),
                ),
              ),
              label: '',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          unselectedItemColor: ThemeColors.grey3,
          selectedItemColor: ThemeColors.primary,
          onTap: (index) => controller.selectedIndex(index),
        ),
      ),
    );
  }

  @override
  void goToParkingEditPage() {
    Get.to(() => ParkingEditView());
  }
}
