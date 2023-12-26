import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/dashboard/views/dashboard_view.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';

class StepTwoWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepTwoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 56),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Expanded(
                child: const Text(
                  'Imagens da vaga',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.getGalleryImages(),
                icon: const Icon(
                  Icons.add,
                  color: ThemeColors.primary,
                ),
              ),
            ],
          ),
        ),
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
          return Center(child: Text('Erro ao carregar imagens da galeria.'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
          itemCount: galleryImages.length,
          itemBuilder: (context, index) {
            final image = galleryImages[index];
            final isSelected = controller.selectedGalleryImages.contains(image);

            return GestureDetector(
              onTap: () {
                // if (isSelected) {
                //   controller.removeSelectedImage(File(image.path));
                // } else {
                //   controller.addSelectedImage(File(image.path));
                // }
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
