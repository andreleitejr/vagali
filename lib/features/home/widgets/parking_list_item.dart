import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/views/parking_details_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart'; // Importe a página de detalhes aqui

class ParkingListItem extends StatelessWidget {
  final Parking parking;

  ParkingListItem({required this.parking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ParkingDetailsView(parking: parking)),
      child: Container(
        width: 225,
        height: 250,
        child: Stack(
          children: [
            if (parking.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BlurHash(
                  imageFit: BoxFit.cover,
                  image: parking.images[0].image,
                  hash: parking.images[0].blurHash,
                ),
              ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 4),
                    const Coolicon(
                      icon: Coolicons.mapPin,
                      color: Colors.white,
                      scale: 1.5,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      parking.distance.formatDistance,
                      style: ThemeTypography.regular14.apply(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parking.name.toUpperCase(),
                    style: ThemeTypography.medium16.apply(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 180,
                    ),
                    child: Text(
                      '${parking.address.street}, ${parking.address.city}',
                      style: ThemeTypography.regular14.apply(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Coolicon(
                        icon: Coolicons.starFilled,
                        color: ThemeColors.primary,
                        scale: 1.75,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.7',
                        style: ThemeTypography.semiBold14.apply(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'R\$${parking.pricePerHour.toStringAsFixed(0)}',
                        style: ThemeTypography.semiBold14.apply(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/ hora',
                        style: ThemeTypography.regular12.apply(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
