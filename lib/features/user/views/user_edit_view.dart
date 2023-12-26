import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/views/parking_edit_view.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/widgets/address_edit_widget.dart';
import 'package:vagali/features/user/widgets/personal_info_edit_widget.dart';
import 'package:vagali/features/vehicle/views/vehicle_edit_view.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class UserEditView extends StatefulWidget {
  final String type;

  const UserEditView({super.key, required this.type});

  @override
  State<UserEditView> createState() => _UserEditViewState();
}

class _UserEditViewState extends State<UserEditView> {
  late UserEditController _controller;
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    _controller = Get.put(UserEditController(widget.type));
    super.initState();
  }

  Future<void> _validateAndNavigateNext() async {
    final isValidStep = _controller.validateCurrentStep(_currentPage);

    if (isValidStep) {
      if (_currentPage < 1) {
        _navigateToNextPage();
      } else {
        await _handleNavigationOnValidStep();
      }
    } else {
      _controller.showErrors(true);
    }
  }

  void _navigateToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage++;
    });
  }

  Future<void> _handleNavigationOnValidStep() async {
    if (_controller.isValid()) {
      final result = await _controller.save();
      if (result == SaveResult.success) {
        _navigateToEditView();
      }
    } else {
      _controller.showErrors(true);
      debugPrint('Is Invalid.');
    }
  }

  void _navigateToEditView() {
    print('###################################');
    print('######### _NAVIGATE TO TARGE HERE  ###########');
    print('###################################');
    final targetView = _controller.type == UserType.tenant
        ? const VehicleEditView()
        : const ParkingEditView();
    Get.to(() => targetView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        showLeading: false,
        title: 'Editar Usuário',
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            PersonalInfoEditWidget(controller: _controller),
            AddressEditWidget(controller: _controller),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(
          () => RoundedGradientButton(
            actionText: 'Avançar',
            onPressed: () => _validateAndNavigateNext(),
            loading: _controller.loading.value,
          ),
        ),
      ),
    );
  }
}
