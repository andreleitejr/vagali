import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/auth/views/auth_view.dart';
import 'package:vagali/features/calendar/views/calendar_view.dart';
import 'package:vagali/features/dashboard/views/dashboard_view.dart';
import 'package:vagali/features/home/landlord/views/landlord_home_view.dart';
import 'package:vagali/theme/theme_colors.dart';

class LandlordBaseView extends StatefulWidget {
  final int selectedIndex;

  const LandlordBaseView({super.key, this.selectedIndex = 0});

  @override
  _LandlordBaseViewState createState() => _LandlordBaseViewState();
}

class _LandlordBaseViewState extends State<LandlordBaseView> {
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: ThemeColors.grey3,
        selectedItemColor: ThemeColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
