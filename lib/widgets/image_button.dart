import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/theme/theme_colors.dart';

enum ImageDataSource {
  network,
  asset,
}

class ImageButton extends StatelessWidget {
  final String? imageUrl;
  final double imageSize;
  final VoidCallback onPressed;
  final ImageDataSource imageDataSource;

  const ImageButton({
    Key? key,
    required this.imageUrl,
    this.imageSize = 100.0,
    required this.onPressed,
    this.imageDataSource = ImageDataSource.network,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipOval(
        child: Container(
          width: imageSize,
          height: imageSize,
          color: ThemeColors.grey1,
          child: imageUrl != null
              ? imageDataSource == ImageDataSource.network
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imageUrl!),
                      fit: BoxFit.cover,
                    )
              : Center(
                  child: Image.asset(
                    Images.camera,
                    width: imageSize * 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
