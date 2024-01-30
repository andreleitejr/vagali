import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/apps/landlord/features/home/views/landlord_base_view.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/theme/images.dart';

class LandlordHomeController extends GetxController {
  LandlordHomeController(this.navigator);

  final HomeNavigator navigator;

  final User landlord = Get.find();
  final _locationService = Get.put(LocationService());
  final _parkingRepository = Get.put(ParkingRepository());
  final _reservationRepository = Get.put(ReservationRepository());
  GoogleMapController? _mapController;

  final parkings = <Parking>[].obs;

  final allReservations = <Reservation>[].obs;
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
    final parkings = await _parkingRepository.getAll(userId: landlord.id);

    if (parkings.isEmpty) {
      navigator.goToParkingEditPage();
      return;
    }

    Get.put(parkings);

    loading(true);

    _listenToReservations();
    await Future.delayed(const Duration(milliseconds: 1500));
    await _loadCarMarker();
    _verifyExpiredReservations();
    _verifyInProgressReservations();
    loading(false);
  }

  void _listenToReservations() {
    _reservationRepository.streamAll().listen((dataList) {
      _processReservationData(dataList);
    });
  }

  Future<void> _processReservationData(List<Reservation> reservations) async {
    allReservations.clear();
    scheduledReservations.clear();
    allReservations.addAll(reservations);

    final scheduled =
        allReservations.where((reservation) => reservation.isScheduled);

    scheduledReservations.assignAll(scheduled);

    if (allReservations.isNotEmpty) {
      final reservationWithUserOnTheWay = allReservations
          .firstWhereOrNull((reservation) => reservation.isUserOnTheWay);
      if (reservationWithUserOnTheWay != null) {
        currentReservation.value = reservationWithUserOnTheWay;
        print(
            '######################################## LISTENING LATITUDE ${currentReservation.value!.locationHistory.last.latitude.toDouble()}');

        print(
            '######################################## LISTENING LONGITUDE ${currentReservation.value!.locationHistory.last.latitude.toDouble()}');
        _updateMarker();

        await _animateCameraToLocation();
        await _calculateAndSetEstimatedArrivalTime();
      } else {
        currentReservation.value = allReservations
            .firstWhereOrNull((reservation) => reservation.isOpen);
      }
    }
  }

  void _verifyExpiredReservations() {
    for (final reservation in allReservations) {
      if (reservation.isExpired) {
        _reservationRepository.updateReservationStatus(
          reservation.id!,
          ReservationStatus.canceled,
        );
      }
    }
  }

  void _verifyInProgressReservations() {
    for (final reservation in allReservations) {
      if (reservation.isUserOnTheWay) return;

      if (reservation.isInProgress) {
        _reservationRepository.updateReservationStatus(
          reservation.id!,
          ReservationStatus.inProgress,
        );
      }
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

// Future<void> _handleReservationsUpdate(
//     Stream<List<Reservation>> stream) async {
//   stream.listen((event) async {
//     allReservations.assignAll(event);
//
//     if (currentReservation.value != null &&
//         currentReservation.value!.isUserOnTheWay) {
//       _updateMarker();
//       await _animateCameraToLocation();
//       await _calculateAndSetEstimatedArrivalTime();
//     }
//
//     scheduledReservations.value = allReservations
//         .where((reservation) => reservation.isScheduled)
//         .toList();
//
//     scheduledReservations.sort((a, b) => a.startDate.compareTo(b.startDate));
//
//     if (scheduledReservations.isNotEmpty) {
//       currentReservation.value = scheduledReservations.first;
//     }
//     loading(false);
//   });
// }

// Future<void> _handleVehicleUpdate(Reservation reservation) async {
//   if (reservation.item == null && reservation.tenant != null) {
//     final tenantId = reservation.tenantId;
//     final vehicleId = reservation.itemId;
//     final vehicles = await _vehicleRepository.getVehiclesFromTenant(tenantId);
//     reservation.item =
//         vehicles?.firstWhereOrNull((vehicle) => vehicle.id == vehicleId);
//   }
// }

  Future<void> _animateCameraToLocation() async {
    final currentPosition = CameraPosition(
      target: LatLng(
        currentReservation.value!.locationHistory.last.latitude.toDouble(),
        currentReservation.value!.locationHistory.last.longitude.toDouble(),
      ),
      zoom: 16,
      // bearing:
      //     currentReservation.value!.locationHistory.last.heading.toDouble(),
    );
    await _mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _calculateAndSetEstimatedArrivalTime() async {
    estimatedArrivalTime.value = await _locationService.calculateEstimatedTime(
      currentReservation.value!.locationHistory.last.latitude.toDouble(),
      currentReservation.value!.locationHistory.last.longitude.toDouble(),
      currentReservation.value!.parking!.location.latitude,
      currentReservation.value!.parking!.location.longitude,
    );
  }

  bool get hasOpenReservation =>
      currentReservation.value != null && currentReservation.value!.isActive;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> updateReservation(ReservationStatus status) async {
    await _reservationRepository.updateReservationStatus(
      currentReservation.value!.id!,
      status,
    );
  }

// Future<void> _getCurrentLandlordLocation() async {
//   await _locationService.getUserLocation();
//   final position = _locationService.userLocation;
//
//   if (position != null) {
//     location.value = LatLng(position.latitude, position.longitude);
//   }
// }

  // var location = const LatLng(-23.5504533, -46.6339112).obs;

  void _updateMarker() {
    marker.value = null;

    print(
        'CURRENT USER LATITUDE: ${currentReservation.value!.locationHistory.last.latitude.toDouble()}');

    print(
        'CURRENT USER LONGITUDE: ${currentReservation.value!.locationHistory.last.latitude.toDouble()}');
    final location = LatLng(
      currentReservation.value!.locationHistory.last.latitude.toDouble(),
      currentReservation.value!.locationHistory.last.longitude.toDouble(),
    );
    marker.value = Marker(
      markerId: const MarkerId('userMarker'),
      position: location,
      icon: carMarkerIcon,
      rotation: 0,
      anchor: Offset(0.5, 0.45),
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
