import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_details_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/carousel_image_slider.dart';
import 'package:vagali/widgets/coolicon.dart'; // Importe a página de detalhes aqui

class ParkingListItem extends StatelessWidget {
  final Parking parking;

  ParkingListItem({required this.parking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ParkingDetailsView(parking: parking)),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 326),
            height: MediaQuery.of(context).size.width - 56,
            child: Stack(
              children: [
                if (parking.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CarouselImageSlider(
                      images: parking.images,
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '${Random().nextInt(6) + 1} pessoas de olho',
                      style: ThemeTypography.regular12,
                    ),
                  ),
                ),
                // Positioned(
                //   top: 16,
                //   right: 16,
                //   child: Opacity(
                //     opacity: 0.35,
                //     child: Coolicon(
                //       height: 24,
                //       width: 24,
                //       icon: Coolicons.heartFill,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 16,
                //   right: 16,
                //   child: Coolicon(
                //     height: 24,
                //     width: 24,
                //     icon: Coolicons.heartOutline,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parking.name,
                  style: ThemeTypography.semiBold14,
                ),
                const SizedBox(height: 8),
                Text(
                  '${parking.distance.formatDistance} ${parking.address.street} de distância',
                  style: ThemeTypography.regular14.apply(
                    color: ThemeColors.grey4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'A partir de R\$${parking.price.hour?.toStringAsFixed(0)}',
                      style: ThemeTypography.semiBold16,
                    ),
                    const SizedBox(width: 4),
                    Text('por hora', style: ThemeTypography.regular16),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
