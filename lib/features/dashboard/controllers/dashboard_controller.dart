import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/tenant/repositories/tenant_repository.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/theme/images.dart';

class DashboardController extends GetxController {
  final Landlord landlord = Get.find();
  final locationService = Get.put(LocationService());
  final _reservationRepository = Get.put(ReservationRepository());
  final _tenantRepository = TenantRepository();
  final _vehicleRepository = VehicleRepository();
  final landlordRepository = LandlordRepository();
  final _parkingRepository = Get.put(ParkingRepository());
  GoogleMapController? _mapController;

  final parkings = <Parking>[].obs;

  final landlordReservations = <Reservation>[].obs;
  final currentLandlordReservation = Rx<Reservation?>(null);
  final tenant = Rx<Tenant?>(null);
  final vehicle = Rx<Vehicle?>(null);
  final Rx<Marker?> marker = Rx<Marker?>(null);
  late BitmapDescriptor carMarkerIcon;
  var loading = false.obs;
  var loadingMap = false.obs;

  var estimatedArrivalTime = Rx<double?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    final stream = _reservationRepository.streamAllReservationsForLandlord();

    loading(true);

    await fetchParkings();
    await _getCurrentLandlordLocation();
    await _loadCarMarker();

    stream.listen((dataList) async {
      landlordReservations.assignAll(dataList);

      var reservation = landlordReservations.firstWhereOrNull((r) => r.isInProgress);

      if (reservation != null) {
        currentLandlordReservation.value = reservation;
        tenant.value ??=
            await _tenantRepository.get(reservation.tenantId) as Tenant;

        if (vehicle.value == null && tenant.value != null) {
          final tenantId = tenant.value!.id!;
          final vehicleId = reservation.vehicleId;
          final vehicles =
              await _vehicleRepository.getVehiclesFromTenant(tenantId);
          vehicle.value =
              vehicles?.firstWhereOrNull((vehicle) => vehicle.id == vehicleId);
        }

        if (reservation.isUserOnTheWay) {
          _updateMarker();

          await _mapController
              ?.animateCamera(CameraUpdate.newLatLng(location.value));

          estimatedArrivalTime.value =
              await locationService.calculateEstimatedTime(
                  location.value.latitude, location.value.longitude);
          print('ARRIVAL TIME HERE: ${estimatedArrivalTime.value}');
          await Future.delayed(const Duration(seconds: 1));

          update();
        }
      }
      loading(false);
    });
  }

  Future<void> fetchParkings() async {
    try {
      final parkings = await _parkingRepository.getAll(userId: landlord.id!);

      parkings.sort((a, b) => a.distance.compareTo(b.distance));

      parkings.assignAll(parkings);

      Get.put<List<Parking>>(parkings, tag: 'parkings');
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  bool get hasOpenReservation =>
      currentLandlordReservation.value != null &&
      currentLandlordReservation.value!.isActive &&
      tenant.value != null &&
      vehicle.value != null;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> fetchReservationsForUser() async {
    final userReservations =
        await _reservationRepository.fetchReservationsForUser(landlord.id!);
    landlordReservations.value = userReservations;
  }

  // Future<void> fetchReservationById(String reservationId) async {
  //   final reservation =
  //       await _reservationRepository.getReservationWithEntities(reservationId);
  //   currentLandlordReservation.value = reservation;
  // }

  Future<void> fetchTenants() async {
    try {
      final tenants = await _tenantRepository.getAll();

      tenant.value = tenants.firstWhereOrNull(
          (t) => t.id == currentLandlordReservation.value?.tenantId);
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  Future<void> verifyStatusAndUpdateReservation() async {
    if (currentLandlordReservation.value?.status ==
        ReservationStatus.paymentApproved) {
      await confirmReservation();
    } else if (currentLandlordReservation.value?.status ==
        ReservationStatus.userOnTheWay) {
      await confirmParkedVehicle();
    }
  }

  Future<void> confirmReservation() async {
    try {
      await _reservationRepository.updateReservationStatus(
        currentLandlordReservation.value!.id!,
        ReservationStatus.confirmed,
      );
    } catch (error) {
      debugPrint('Erro ao confirmar a reserva: $error');
    }
  }

  Future<void> confirmParkedVehicle() async {
    try {
      await _reservationRepository.updateReservationStatus(
        currentLandlordReservation.value!.id!,
        ReservationStatus.parked,
      );
    } catch (error) {
      debugPrint('Erro ao confirmar a reserva: $error');
    }
  }

  Future<void> _getCurrentLandlordLocation() async {
    final position = locationService.userLocation;

    if (position != null) {
      location.value = LatLng(position.latitude, position.longitude);
    }
  }

  var location = const LatLng(-23.5504533, -46.6339112).obs;

  void _updateMarker() {
    location.value = LatLng(
      currentLandlordReservation.value!.locationHistory.last.latitude,
      currentLandlordReservation.value!.locationHistory.last.longitude,
    );
    marker.value = Marker(
      markerId: const MarkerId('userMarker'),
      position: location.value,
      icon: carMarkerIcon,
      rotation: currentLandlordReservation.value!.locationHistory.last.heading,
    );
  }

  Future<void> loadMapStyle(GoogleMapController controller) async {
    final String styleString =
        await rootBundle.loadString('assets/map_style.json');

    controller.setMapStyle(styleString);
  }

  Future<void> _loadCarMarker() async {
    final Uint8List markerIconData = await getBytesFromAsset(Images.car, 250);
    carMarkerIcon = BitmapDescriptor.fromBytes(markerIconData);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final frameInfo = await codec.getNextFrame();
    final byteData =
        await frameInfo.image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
