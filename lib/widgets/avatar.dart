import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:vagali/models/image_blurhash.dart';

class Avatar extends StatelessWidget {
  final ImageBlurHash image;

  const Avatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF02C39A),
            Color(0xFF0077B6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
