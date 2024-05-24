import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/views/landlord_base_view.dart';
import 'package:vagali/features/landlord/controllers/landlord_edit_controller.dart';
import 'package:vagali/features/landlord/widgets/landlord_address_widget.dart';
import 'package:vagali/features/landlord/widgets/landlord_personal_info_widget.dart';
import 'package:vagali/features/parking/views/parking_edit_view.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loading_view.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class LandlordEditView extends StatefulWidget {
  final User? user;

  const LandlordEditView({super.key, this.user});

  @override
  State<LandlordEditView> createState() => _LandlordEditViewState();
}

class _LandlordEditViewState extends State<LandlordEditView> {
  late LandlordEditController _controller;
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    _controller = Get.put(LandlordEditController());
    super.initState();
  }

  Future<void> _validateAndNavigateNext() async {
    final isValidStep = _controller.validateCurrentStep(_currentPage).value;

    if (isValidStep) {
      if (_currentPage < 1) {
        _controller.showErrors(false);
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
      // await _controller.uploadImage();
      final result = await _controller.save();
      Future.delayed(const Duration(seconds: 1));
      if (result == SaveResult.success) {
        _navigateToEditView();
      }
    } else {
      _controller.showErrors(true);
      debugPrint('Is Invalid.');
    }
  }

  void _navigateToEditView() {
    FocusScope.of(context).unfocus();

    Get.to(
      () => ParkingEditView(
        onConcluded: () => Get.to(() => LandlordBaseView()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        showLeading: widget.user != null,
        title: 'Editar Usuário',
        actions: [
          Obx(
            () => TextButton(
              onPressed: () => _validateAndNavigateNext(),
              child: Text(
                'Avancar',
                style: ThemeTypography.medium14.apply(
                  color: _controller.validateCurrentStep(_currentPage).isTrue
                      ? ThemeColors.primary
                      : ThemeColors.grey3,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => _controller.loading.isTrue
            ? LoadingView(message: 'Criando perfil de usuário')
            : Container(
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
                    LandlordPersonalInfoWidget(controller: _controller),
                    LandlordAddressWidget(controller: _controller),
                  ],
                ),
              ),
      ),
    );
  }
}
