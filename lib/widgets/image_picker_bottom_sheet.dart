import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_text.dart';

Future<ImageSource?> showImagePickerBottomSheet(BuildContext context) async {
  return await showModalBottomSheet<ImageSource>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    context: context,
    builder: (ctx) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: GradientText(
              'Como quer selecionar sua foto?',
              style: ThemeTypography.semiBold14,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Câmera'),
            onTap: () => Get.back(result: ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeria'),
            onTap: () => Get.back(result: ImageSource.gallery),
          ),
          const SizedBox(height: 24),
        ],
      );
    },
  );
}
