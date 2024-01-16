import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/address/controllers/address_controller.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';

// ignore: must_be_immutable
class AddressCard extends StatelessWidget {
  final bool editModeOn;
  final Address address;
  late AddressController addressController;

  AddressCard({
    super.key,
    required this.address,
    this.editModeOn = true,
  }) {
    addressController = Get.put(AddressController(address));
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
              const Coolicon(
                icon: Coolicons.noteEdit,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Coolicon(
              icon: Coolicons.mapPin,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                fullAddress,
                style: ThemeTypography.regular14,
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

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentCoordinates.latitude,
                    currentCoordinates.longitude,
                  ),
                  zoom: 15.0,
                ),
                markers: {
                  addressController.marker.value ??
                      Marker(
                        markerId: MarkerId('location'),
                        position: LatLng(currentCoordinates.latitude,
                            currentCoordinates.longitude),
                      ),
                },
                onMapCreated: (GoogleMapController controller) {
                  addressController.loadMapStyle(controller);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
