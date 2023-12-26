import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:vagali/features/dashboard/views/dashboard_view.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_five.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_four.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_one.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_three.dart';
import 'package:vagali/features/parking/widgets/parking_edit_step_two.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/logo.dart';

import 'package:vagali/widgets/rounded_gradient_button.dart';

class ParkingEditView extends StatefulWidget {
  const ParkingEditView({Key? key}) : super(key: key);

  @override
  _ParkingEditViewState createState() => _ParkingEditViewState();
}

class _ParkingEditViewState extends State<ParkingEditView> {
  final _controller = Get.put(ParkingEditController());
  final _pageController = PageController();
  int _currentPage = 0;

  Future<void> _validateAndNavigateNext() async {
    if (_controller.validateCurrentStep(_currentPage)) {
      if (_currentPage < _controller.totalSteps - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        if (_currentPage == 0) {
          await _controller.getGalleryImages();
        }
        setState(() {
          _currentPage++;
        });
      } else {
        await _controller.save();

        Get.to(() => DashboardView());
      }
    } else {
      _controller.showErrors(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _controller.loading.isTrue
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF02C39A),
                    Color(0xFF0077B6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(hasDarkBackground: true),
                  const SizedBox(height: 64),
                  Text(
                    'Configurando seu painel',
                    style: ThemeTypography.medium16.apply(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  JumpingDots(
                    verticalOffset: -7,
                    color: Colors.white,
                    radius: 6,
                    numberOfDots: 3,
                    // animationDuration = Duration(milliseconds: 200),
                  ),
                ],
              ),
            )
          : PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // Etapa 1: Nome, Preço, Descrição e Endereço
                StepOneWidget(controller: _controller),

                // Etapa 2: Selecionar Fotos da Garagem
                StepTwoWidget(controller: _controller),

                // Etapa 3: Horários de Funcionamento
                StepThreeWidget(controller: _controller),

                // Etapa 4: Tags do Portão
                StepFourWidget(controller: _controller),

                // Etapa 5: Informações do Portão
                StepFiveWidget(controller: _controller),
              ],
            )),
      bottomNavigationBar: Obx(
        () => _controller.loading.isTrue
            ? const SizedBox(height: 0)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: RoundedGradientButton(
                  actionText: _currentPage < _controller.totalSteps - 1
                      ? 'Avançar'
                      : 'Salvar',
                  onPressed: _validateAndNavigateNext,
                ),
              ),
      ),
    );
  }
}
