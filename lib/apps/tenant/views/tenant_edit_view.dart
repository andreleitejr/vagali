import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/controllers/tenant_edit_controller.dart';
import 'package:vagali/apps/tenant/features/home/views/base_view.dart';
import 'package:vagali/apps/tenant/widgets/tenant_address_widget.dart';
import 'package:vagali/apps/tenant/widgets/tenant_personal_info_widget.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loading_view.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class TenantEditView extends StatefulWidget {
  final User? user;

  const TenantEditView({super.key, this.user});

  @override
  State<TenantEditView> createState() => _TenantEditViewState();
}

class _TenantEditViewState extends State<TenantEditView> {
  late TenantEditController _controller;
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    _controller = Get.put(TenantEditController());
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
      final result = await _controller.save();
      if (result == SaveResult.success) {
        Get.offAllNamed('/home');
      }
    } else {
      _controller.showErrors(true);
      debugPrint('Is Invalid.');
    }
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
                    TenantPersonalInfoWidget(controller: _controller),
                    TenantAddressWidget(controller: _controller),
                  ],
                ),
              ),
      ),
    );
  }
}
