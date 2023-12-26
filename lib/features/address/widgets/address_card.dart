import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/address/controllers/address_controller.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/services/address_service.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';

class AddressCard extends StatefulWidget {
  final bool editionModeOn;
  final Address address;
  late AddressController addressController;

  AddressCard({
    super.key,
    required this.address,
    this.editionModeOn = true,
  }) {
    addressController = Get.put(AddressController(address));
  }

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    final fullAddress =
        '${widget.address.street ?? ''}, ${widget.address.number ?? ''} - ${widget.address.city}, ${widget.address.state} - ${widget.address.country}';

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
            if (widget.editionModeOn)
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
              scale: 1.4,
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
              final currentCoordinates =
                  widget.addressController.coordinates.value;

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
                  widget.addressController.marker.value ??
                      Marker(
                        markerId: MarkerId('location'),
                        position: LatLng(currentCoordinates.latitude,
                            currentCoordinates.longitude),
                      ),
                },
                onMapCreated: (GoogleMapController controller) {
                  widget.addressController.loadMapStyle(controller);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
