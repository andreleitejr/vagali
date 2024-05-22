import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_list_controller.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_edit_option_view.dart';
import 'package:vagali/apps/landlord/features/parking/views/parking_edit_view.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingListView extends StatelessWidget {
  final controller = Get.put(ParkingListController());

  ParkingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Minhas vagas',
        actions: [
          TextButton(
            onPressed: () async {
              await Get.to(
                () => ParkingEditView(onConcluded: () => Get.back()),
              );
              controller.fetchUserParkings();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                'Nova vaga',
                style: ThemeTypography.medium14,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final parkings = controller.parkings;
        if (parkings.isEmpty) {
          return Loader(
            message: 'Carregando vagas...',
          );
        }

        return ListView.builder(
          itemCount: parkings.length,
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final parking = parkings[index];

            return parkingListItem(parking);
          },
        );
      }),
    );
  }

  Widget parkingListItem(Parking parking) {
    return GestureDetector(
      onTap: () => Get.to(() => ParkingEditOptionView(parking: parking)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.75, color: ThemeColors.grey2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BlurHash(
                  imageFit: BoxFit.cover,
                  image: parking.images.first.image,
                  hash: parking.images.first.blurHash,
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
                      Text(
                        parking.name,
                        style: ThemeTypography.semiBold14,
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
