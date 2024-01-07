import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/widgets/vehicle_info_widget.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/user_card.dart';

class TrackingLocation extends StatelessWidget {
  final DashboardController controller;

  const TrackingLocation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
              child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Obx(
                  () => GoogleMap(
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ],
          )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // color: Colors.white,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Estimativa de chegada',
                          style: ThemeTypography.medium16,
                        ),
                      ),
                      // Text(
                      //   controller.estimatedArrivalTime.value!.toTimeString(),
                      //   style: ThemeTypography.medium16,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  UserCard(
                    user: controller.tenant.value as User,
                    message: controller
                        .currentLandlordReservation.value!.reservationMessage,
                  ),
                  const SizedBox(height: 16),
                  VehicleInfoWidget(
                    vehicle: controller.vehicle.value!,
                  ),
                  const SizedBox(height: 16),
                  RoundedGradientButton(
                    onPressed: () =>
                        controller.verifyStatusAndUpdateReservation(),
                    actionText: 'Confirmar estacionamento',
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
