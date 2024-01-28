import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/controllers/parking_details_controller.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/reservation/views/reservation_edit_view.dart';
import 'package:vagali/services/share_service.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/carousel_image_slider.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/over_image_button.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/tag_list.dart';
import 'package:vagali/widgets/user_card.dart';

class ParkingDetailsView extends StatelessWidget {
  final Parking parking;
  final ParkingDetailsController controller;

  ParkingDetailsView({Key? key, required this.parking})
      : controller = Get.put(ParkingDetailsController(parking)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 360,
                ),
                child: CarouselImageSlider(
                  images: parking.images,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _appBarButtons(
                        icon: Coolicons.chevronBidLeft,
                        onTap: () => Get.back(),
                      ),
                      Expanded(child: Container()),
                      _appBarButtons(
                        icon: Coolicons.share,
                        onTap: () async {
                          final shareService = ShareService();
                          await shareService.shareParking(
                            controller.parking.value!
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _appBarButtons(
                        icon: Coolicons.heartOutline,
                        onTap: () => Get.back(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(
              parking.name,
              style: ThemeTypography.semiBold16,
            ),
          ),
          TagList(tags: parking.tags),
          const SizedBox(height: 16),
          if (parking.owner != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: UserCard(user: parking.owner!),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AddressCard(
              address: parking.address,
              editModeOn: false,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: const Text(
              'Descrição',
              style: ThemeTypography.semiBold16,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                parking.description,
                style: ThemeTypography.regular14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 8. Horários de operação.
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children:  controller.parking.operatingHours.daysAndHours.keys
          //       .map((day) {
          //     final hours =
          //          controller.parking.operatingHours.daysAndHours[day];
          //     return ListTile(
          //       title: Text(day),
          //       subtitle: Text(hours!.values.toString()),
          //     );
          //   }).toList(),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     Get.to(() =>
          //         ReservationEditView(parking:parking));
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blue,
          //   ),
          //   child: Text('Fazer Reserva'),
          // ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preço:',
                    style: ThemeTypography.regular12,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'R\$${parking.price.hour?.toStringAsFixed(2)}',
                        style: ThemeTypography.semiBold22,
                      ),
                      const Text(
                        ' / hora  ',
                        style: ThemeTypography.regular12,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: FlatButton(
                actionText: 'Reservar',
                onPressed: () {
                  Get.to(() => ReservationEditView(parking: parking));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appBarButtons({required String icon, required VoidCallback onTap}) {
    return OverImageButton(icon: icon, onTap: onTap);
  }
}
