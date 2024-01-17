import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/image_picker_bottom_sheet.dart';
import 'package:vagali/widgets/over_image_button.dart';
import 'package:vagali/widgets/warning_dialog.dart';

class StepTwoWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepTwoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.selectedGalleryImages.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${controller.selectedGalleryImages.length} imagens',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final source = await showImagePickerBottomSheet(context);

                      if (source != null) {
                        await controller.pickImages(source);
                      }
                    },
                    child: Text(
                      'Adicionar imagens',
                      style: ThemeTypography.medium16.apply(
                        color: ThemeColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        }),
        Expanded(
          child: GalleryImageSelectionPage(),
        ),
      ],
    );
  }
}

class GalleryImageSelectionPage extends StatelessWidget {
  final ParkingEditController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final galleryImages = controller.selectedGalleryImages;

        if (galleryImages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nenhuma imagem selecionada.\nPor favor, selecione imagens de sua vaga.',
                  style: ThemeTypography.medium16,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FlatButton(
                  onPressed: () async {
                    final source = await showImagePickerBottomSheet(context);

                    if (source != null) {
                      await controller.pickImages(source);
                    }
                  },
                  actionText: 'Selecionar imagem',
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
          itemCount: galleryImages.length,
          itemBuilder: (context, index) {
            final image = galleryImages[index];
            final isSelected = controller.selectedGalleryImages.contains(image);

            return Stack(
              alignment: Alignment.topRight,
              children: [
                Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OverImageButton(
                      icon: Coolicons.trashFull,
                      onTap: () => showWarningDialog(
                        context,
                        title: 'Deletar a imagem',
                        description:
                            'Tem certeza que gostaria de deletar a imagem?',
                        onConfirm: () => controller.removeSelectedImage(image),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      }),
    );
  }
}
