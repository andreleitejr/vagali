import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:vagali/models/image_blurhash.dart';

class Avatar extends StatelessWidget {
  final ImageBlurHash image;
  final bool isSelected;
  final double height;
  final double width;


  const Avatar({
    super.key,
    required this.image,
    this.height = 42,
    this.width = 42,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [
                  Color(0xFF02C39A),
                  Color(0xFF0077B6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        height: 42,
        width: 42,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BlurHash(
            imageFit: BoxFit.cover,
            image: image.image,
            hash: image.blurHash,
          ),
        ),
      ),
    );
  }
}
