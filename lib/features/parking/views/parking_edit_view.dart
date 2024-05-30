import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/views/landlord_base_view.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/widgets/parking_edit_address.dart';
import 'package:vagali/features/parking/widgets/parking_edit_price.dart';
import 'package:vagali/features/parking/widgets/parking_edit_tags.dart';
import 'package:vagali/features/parking/widgets/parking_edit_information.dart';
import 'package:vagali/features/parking/widgets/parking_edit_gate.dart';
import 'package:vagali/features/parking/widgets/parking_edit_images.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loading_view.dart';
import 'package:vagali/widgets/snackbar.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingEditView extends StatefulWidget {
  final VoidCallback onConcluded;

  const ParkingEditView({Key? key, required this.onConcluded})
      : super(key: key);

  @override
  _ParkingEditViewState createState() => _ParkingEditViewState();
}

class _ParkingEditViewState extends State<ParkingEditView> {
  final _controller = Get.put(ParkingEditController(null));
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
        if (_currentPage == 2) {
          await _controller.pickImagesFromGallery();
        }
      } else {
        try {
          final result = await _controller.save();

          if (result == SaveResult.success) {
            widget.onConcluded();
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
      if (_controller.loading.isTrue) {
        return LoadingView(message: 'Salvando...');
      }
      return Scaffold(
        appBar: TopNavigationBar(
          // showLeading: false,
          title: 'Editar Vaga',
          onLeadingPressed: () {
            if (_currentPage >= 1) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );

              setState(() {
                _currentPage--;
              });
            } else {
              Get.back();
            }
          },
          actions: [
            Obx(
              () => TextButton(
                onPressed: () => _validateAndNavigateNext(),
                child: Text(
                  _currentPage == 5 ? 'Salvar' : 'Avancar',
                  style: ThemeTypography.semiBold14.apply(
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

            // Etapa 2: Nome e Descrição
            ParkingEditInformation(controller: _controller),

            // Etapa 3: Selecionar Fotos da Garagem
            ParkingEditImages(controller: _controller),

            // Etapa 4: Informações do Portão
            ParkingEditGate(controller: _controller),

            // Etapa 5: Tags da vaga
            ParkingEditTags(controller: _controller),

            // Etapa 6: Informações do Preço
            ParkingEditPrice(controller: _controller),
          ],
        ),
      );
    });
  }
}
