import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/home/views/landlord_base_view.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/apps/landlord/features/parking/widgets/parking_edit_step_five.dart';
import 'package:vagali/apps/landlord/features/parking/widgets/parking_edit_step_four.dart';
import 'package:vagali/apps/landlord/features/parking/widgets/parking_edit_step_one.dart';
import 'package:vagali/apps/landlord/features/parking/widgets/parking_edit_step_three.dart';
import 'package:vagali/apps/landlord/features/parking/widgets/parking_edit_step_two.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loading_view.dart';
import 'package:vagali/widgets/snackbar.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

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
    if (_controller.validateCurrentStep(_currentPage).isTrue) {
      if (_currentPage < _controller.totalSteps - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        setState(() {
          _currentPage++;
        });
        if (_currentPage == 1) {
          await _controller.pickImagesFromGallery();
        }
      } else {
        try {
          final result = await _controller.save();

          if (result == SaveResult.success) {
            Get.to(() => LandlordBaseView());
          }
        } catch (e) {
          snackBar('Erro', e.toString());
        }
      }
    } else {
      _controller.showErrors(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(_controller.loading.isTrue){
        return LoadingView(message: 'Configurando usuário...');
      }
      return Scaffold(
        appBar: TopNavigationBar(
          // showLeading: false,
          title: 'Editar Vaga',
          onLeadingPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );

            setState(() {
              _currentPage--;
            });
          },
          actions: [
            Obx(
              () => TextButton(
                onPressed: () => _validateAndNavigateNext(),
                child: Text(
                  'Avancar',
                  style: ThemeTypography.semiBold16.apply(
                    color: _controller.validateCurrentStep(_currentPage).isTrue
                        ? ThemeColors.primary
                        : ThemeColors.grey3,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: PageView(
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

            // Etapa 3: Informações do Portão
            StepThreeWidget(controller: _controller),

            // Etapa 4: Tags da vaga
            StepFourWidget(controller: _controller),

            // Etapa 5: Informações do Portão
            StepFiveWidget(controller: _controller),
          ],
        ),
      );
    });
  }
}
