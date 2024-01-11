import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/tenant/repositories/tenant_repository.dart';
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

  final reservations = <Reservation>[].obs;
  final currentReservation = Rx<Reservation?>(null);

  final scheduledReservations = <Reservation>[].obs;

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
      await _getCurrentLandlordLocation();
      await _loadCarMarker();

      await _handleReservationsUpdate(stream);
    } finally {
      loading(false);
    }
  }

  String getGreeting() {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;

    if (hour >= 6 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  Future<void> _handleReservationsUpdate(
      Stream<List<Reservation>> stream) async {
    stream.listen((event) async {
      reservations.assignAll(event);


      _getScheduledReservation();

      for (final reservation in reservations) {
        reservation.tenant ??=
            await _tenantRepository.get(reservation.tenantId) as Tenant;

        await _handleVehicleUpdate(reservation);

        if (currentReservation.value != null &&
            currentReservation.value!.isUserOnTheWay) {
          _updateMarker();
          await _animateCameraToLocation();
          await _calculateAndSetEstimatedArrivalTime();
        }

        update();
      }

      currentReservation.value = scheduledReservations.first;
    });
  }

  void _getScheduledReservation() {
    scheduledReservations.value =
        reservations.where((reservation) => reservation.isScheduled).toList();

    scheduledReservations.sort((a, b)=>a.startDate.compareTo(b.startDate));
  }

  Future<void> _handleVehicleUpdate(Reservation reservation) async {
    if (reservation.vehicle == null && reservation.tenant != null) {
      final tenantId = reservation.tenantId;
      final vehicleId = reservation.vehicleId;
      final vehicles = await _vehicleRepository.getVehiclesFromTenant(tenantId);
      reservation.vehicle =
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
      currentReservation.value != null && currentReservation.value!.isActive;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> verifyStatusAndUpdateReservation() async {
    if (currentReservation.value?.status == ReservationStatus.paymentApproved) {
      await confirmReservation();
    } else if (currentReservation.value?.status ==
        ReservationStatus.userOnTheWay) {
      await confirmParkedVehicle();
    }
  }

  Future<void> confirmReservation() async {
    try {
      await _reservationRepository.updateReservationStatus(
        currentReservation.value!.id!,
        ReservationStatus.confirmed,
      );
    } catch (error) {
      debugPrint('Erro ao confirmar a reserva: $error');
    }
  }

  Future<void> denyReservation() async {
    try {
      await _reservationRepository.updateReservationStatus(
        currentReservation.value!.id!,
        ReservationStatus.canceled,
      );
    } catch (error) {
      debugPrint('Erro ao cancelar a reserva: $error');
    }
  }

  Future<void> confirmParkedVehicle() async {
    try {
      await _reservationRepository.updateReservationStatus(
        currentReservation.value!.id!,
        ReservationStatus.parked,
      );
    } catch (error) {
      debugPrint('Erro ao confirmar a reserva: $error');
    }
  }

  Future<void> _getCurrentLandlordLocation() async {
    await locationService.getUserLocation();
    final position = locationService.userLocation;

    if (position != null) {
      location.value = LatLng(position.latitude, position.longitude);
    }
  }

  var location = const LatLng(-23.5504533, -46.6339112).obs;

  void _updateMarker() {
    location.value = LatLng(
      currentReservation.value!.locationHistory.last.latitude as double,
      currentReservation.value!.locationHistory.last.longitude as double,
    );
    marker.value = Marker(
      markerId: const MarkerId('userMarker'),
      position: location.value,
      icon: carMarkerIcon,
      rotation:
          currentReservation.value!.locationHistory.last.heading as double,
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
