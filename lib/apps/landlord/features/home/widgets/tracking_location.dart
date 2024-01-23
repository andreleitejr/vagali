import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/apps/landlord/features/home/controllers/dashboard_controller.dart';
import 'package:vagali/apps/tenant/features/vehicle/widgets/vehicle_info_widget.dart';
import 'package:vagali/features/chat/views/chat_view.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/over_image_button.dart';
import 'package:vagali/widgets/user_card.dart';

class TrackingLocation extends StatelessWidget {
  final LandlordHomeController controller;

  const TrackingLocation({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Obx(
              () => Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.location.value,
                        zoom: 16,
                      ),
                      markers: controller.marker.value != null
                          ? {controller.marker.value!}
                          : {
                              Marker(
                                markerId: const MarkerId('userMarker'),
                                position: controller.location.value,
                                icon: controller.carMarkerIcon,
                              ),
                            },
                      onMapCreated: (GoogleMapController mapController) {
                        controller.loadMapStyle(mapController);
                        controller.onMapCreated(mapController);
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                ],
              ),
            ),
            Positioned(
              top: 32,
              left: 16,
              child: OverImageButton(
                icon: Coolicons.chevronBidLeft,
                onTap: () => Get.back(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Estimativa de chegada',
                            style: ThemeTypography.medium14,
                          ),
                        ),
                        if (controller.estimatedArrivalTime.value != null)
                          Text(
                            controller.estimatedArrivalTime.value!
                                .toFormattedTime(),
                            style: ThemeTypography.medium14,
                          ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          UserCard(
                            user: controller.currentReservation.value!.tenant
                                as User,
                            message: controller
                                .currentReservation.value!.reservationMessage,
                          ),
                          const SizedBox(height: 16),
                          VehicleInfoWidget(
                            vehicle:
                                controller.currentReservation.value!.vehicle!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FlatButton(
                      onPressed: () =>
                          controller.verifyStatusAndUpdateReservation(),
                      actionText: 'Confirmar estacionamento',
                    ),
                    const SizedBox(height: 16),
                    FlatButton(
                      onPressed: () => Get.to(
                        () => ChatView(
                            reservation: controller.currentReservation.value!),
                      ),
                      backgroundColor: ThemeColors.secondary,
                      actionText: 'Conversar com locatário',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
