import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/tenant/repositories/tenant_repository.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/theme/images.dart';

class LandlordHomeController extends GetxController {
  final Landlord landlord = Get.find();
  final locationService = Get.put(LocationService());
  final _reservationRepository = Get.put(ReservationRepository());
  final _tenantRepository = TenantRepository();
  final _vehicleRepository = VehicleRepository();
  final landlordRepository = LandlordRepository();
  GoogleMapController? _mapController;

  final parkings = <Parking>[].obs;

  final landlordReservations = <Reservation>[].obs;
  final currentLandlordReservation = Rx<Reservation?>(null);

  final tenant = Rx<Tenant?>(null);
  final vehicle = Rx<Vehicle?>(null);

  final Rx<Marker?> marker = Rx<Marker?>(null);
  late BitmapDescriptor carMarkerIcon;

  var selectedIndex = 0.obs;

  var loading = false.obs;
  var loadingMap = false.obs;

  var estimatedArrivalTime = Rx<double?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    final stream = _reservationRepository.streamAllReservationsForLandlord();

    loading(true);

    try {
      // await fetchParkings();
      await _getCurrentLandlordLocation();
      await _loadCarMarker();

      await for (var dataList in stream) {
        await _handleReservationsUpdate(dataList);
        break;
      }
    } finally {
      print('${currentLandlordReservation.value?.tenant?.firstName}');
      loading(false);
    }
  }

  Future<void> _handleReservationsUpdate(List<Reservation> dataList) async {
    landlordReservations.assignAll(dataList);

    for (final reservation in landlordReservations) {
      reservation.tenant ??=
          await _tenantRepository.get(reservation.tenantId) as Tenant;

      await _handleVehicleUpdate(reservation);

      if (reservation.isUserOnTheWay) {
        _updateMarker();
        await _animateCameraToLocation();
        await _calculateAndSetEstimatedArrivalTime();
      }

      update();
    }

    currentLandlordReservation.value = landlordReservations
        .firstWhereOrNull((reservation) => reservation.isInProgress);
  }

  Future<void> _handleVehicleUpdate(Reservation reservation) async {
    if (reservation.vehicle == null && reservation.tenant != null) {
      final tenantId = reservation.tenantId;
      final vehicleId = reservation.vehicleId;
      final vehicles = await _vehicleRepository.getVehiclesFromTenant(tenantId);
      vehicle.value =
          vehicles?.firstWhereOrNull((vehicle) => vehicle.id == vehicleId);
    }
  }

  Future<void> _animateCameraToLocation() async {
    await _mapController?.animateCamera(CameraUpdate.newLatLng(location.value));
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _calculateAndSetEstimatedArrivalTime() async {
    estimatedArrivalTime.value = await locationService.calculateEstimatedTime(
        location.value.latitude, location.value.longitude);
  }

  bool get hasOpenReservation =>
      currentLandlordReservation.value != null &&
      currentLandlordReservation.value!.isActive;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
