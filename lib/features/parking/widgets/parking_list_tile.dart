import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/views/parking_details_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/custom_icon.dart';
import 'package:vagali/widgets/shimmer_box.dart';

class ParkingListTile extends StatelessWidget {
  final Parking parking;
  final bool loading;

  const ParkingListTile({
    super.key,
    required this.parking,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => ParkingDetailsView(
          parking: parking,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.75,
              color: ThemeColors.grey2,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              loading: loading,
              child: SizedBox(
                width: 64,
                height: 64,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BlurHash(
                    imageFit: BoxFit.cover,
                    image: parking.images.first.image,
                    hash: parking.images.first.blurHash,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerBox(
                        loading: loading,
                        child: Text(
                          parking.name,
                          style: ThemeTypography.semiBold14,
                        ),
                      ),
                      ShimmerBox(
                        loading: loading,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                const CustomIcon(
                                  icon: ThemeIcons.mapPin,
                                  color: ThemeColors.primary,
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  parking.distance.formatDistance,
                                  style: ThemeTypography.semiBold14.apply(
                                    color: ThemeColors.grey4,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  color: loading
                                      ? Colors.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ShimmerBox(
                    loading: loading,
                    child: Text(
                      parking.description,
                      style: ThemeTypography.regular12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ShimmerBox(
                    loading: loading,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // const Coolicon(
                            //   icon: Coolicons.starFilled,
                            //   color: ThemeColors.primary,
                            // ),
                            // const SizedBox(width: 4),
                            // const Text(
                            //   '4.7',
                            //   style: ThemeTypography.semiBold14,
                            // ),
                            // const SizedBox(width: 8),
                            // Container(
                            //   width: 4,
                            //   height: 4,
                            //   decoration: BoxDecoration(
                            //     color: Colors.black,
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            // ),
                            // const SizedBox(width: 8),
                            Text(
                              'A partir de R\$${parking.price.hour?.toStringAsFixed(0)}',
                              style: ThemeTypography.semiBold14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'por hora',
                              style: ThemeTypography.regular14,
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              color:
                                  loading ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
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
