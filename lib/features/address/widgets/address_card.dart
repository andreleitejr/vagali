import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/address/controllers/address_card_controller.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';

// ignore: must_be_immutable
class AddressCard extends StatelessWidget {
  final Address address;
  final bool isReservationActive;
  final VoidCallback? onEditPressed;
  final bool editModeOn;
  late AddressCardController addressController;

  AddressCard({
    super.key,
    required this.address,
    this.editModeOn = false,
    this.onEditPressed,
    this.isReservationActive = false,
  }) {
    addressController = Get.put(AddressCardController(address));
  }

  @override
  Widget build(BuildContext context) {
    final fullAddress =
        '${address.street}, ${address.number} - ${address.city}, ${address.state} - ${address.country}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Endereço da vaga:',
                style: ThemeTypography.medium16,
              ),
            ),
            if (editModeOn)
              CustomIcon(
                onTap: onEditPressed,
                icon: ThemeIcons.noteEdit,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CustomIcon(
              icon: ThemeIcons.mapPin,
              width: 14,
              color: ThemeColors.grey4,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                // fullAddress,
                isReservationActive
                    ? fullAddress
                    : 'O endereço ficará visível após a confirmação da reserva',
                style: ThemeTypography.regular12.apply(
                  color: ThemeColors.grey4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: Obx(
            () {
              final currentCoordinates = addressController.coordinates.value;

              if (currentCoordinates == null) return Container();

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentCoordinates.latitude,
                        currentCoordinates.longitude,
                      ),
                      zoom: isReservationActive ? 15 : 13,
                    ),
                    markers: isReservationActive
                        ? {
                            addressController.marker.value ??
                                Marker(
                                  markerId: MarkerId('location'),
                                  position: LatLng(
                                    currentCoordinates.latitude,
                                    currentCoordinates.longitude,
                                  ),
                                ),
                          }
                        : {},
                    onMapCreated: (GoogleMapController controller) {
                      addressController.loadMapStyle(controller);
                    },
                  ),
                  // if (!isReservationActive) ...[
                  //   Positioned(
                  //     child: Container(
                  //       color: Colors.white.withOpacity(0.5),
                  //     ),
                  //   ),
                  // ]
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
