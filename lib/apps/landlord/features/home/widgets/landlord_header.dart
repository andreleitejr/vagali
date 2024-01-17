import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:vagali/apps/landlord/features/home/controllers/landlord_controller.dart';
import 'package:vagali/theme/theme_typography.dart';

class LandlordHeader extends StatelessWidget {

  final LandlordController controller;
  const LandlordHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 324,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 245,
            width: MediaQuery.of(context).size.width,
            child: BlurHash(
              imageFit: BoxFit.cover,
              image: controller.parkingImage.image,
              hash: controller.parkingImage.blurHash,
            ),
          ),
          Container(
            height: 245,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xAA000000),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 32,
            child: Text(
              'Meu perfil',
              textAlign: TextAlign.center,
              style: ThemeTypography.semiBold16.apply(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: (MediaQuery.of(context).size.width - 158) / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Stack(
                children: [
                  Container(
                    height: 158,
                    width: 158,
                    color: Colors.white,
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    bottom: 4,
                    left: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BlurHash(
                        imageFit: BoxFit.cover,
                        image: controller.image.image,
                        hash: controller.image.blurHash,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
