import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/calendar/views/calendar_view.dart';
import 'package:vagali/features/dashboard/views/dashboard_view.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
import 'package:vagali/features/home/landlord/views/landlord_home_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/avatar.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/shimmer_box.dart';

class LandlordBaseView extends StatefulWidget {
  final int selectedIndex;

  const LandlordBaseView({super.key, this.selectedIndex = 0});

  @override
  _LandlordBaseViewState createState() => _LandlordBaseViewState();
}

class _LandlordBaseViewState extends State<LandlordBaseView> {
  final controller = Get.put(LandlordHomeController());
  final List<Widget> _pages = [
    LandlordHomeView(),
    DashboardView(),
    CalendarView(),
    Column(
      children: [
        Expanded(child: Container()),
        Text('Pagina de Profile'),
        Expanded(child: Container()),
        TextButton(
          onPressed: () async {
            final AuthRepository _authRepository = Get.find();
            await _authRepository.signOut();
            Get.to(() => AuthView());
          },
          child: Text(
            'Sair da conta',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        )
      ],
    ),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
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
}
