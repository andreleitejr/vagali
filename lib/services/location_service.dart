import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/models/location_history.dart';

class LocationService {
  final ReservationRepository _reservationRepository = ReservationRepository();

  Position? _userLocation;

  Position? get userLocation => _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;

  Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print('Erro ao obter a localização: $e');
      return null;
    }
  }

  Future<bool> checkLocationPermission() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    try {
      final LocationPermission permission =
          await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      print('Erro ao solicitar permissão de localização: $e');
      return false;
    }
  }

  bool isTracking = false;

  Future<void> startLocationTracking(Reservation reservation) async {
    print('############################### Service | startLocationTracking');

    print(
        '############################### Service | startLocationTracking | ${userLocation?.latitude} ${userLocation?.longitude}');
    isTracking = true;

    print(
        '############################### Service | startLocationTracking | Is Tracking: $isTracking');
    while (isTracking) {
      print(
          '############################### Service | startLocationTracking |  Is user on the way: ${reservation.status} ${reservation.isUserOnTheWay}');

      if (!reservation.isUserOnTheWay) {
        print('Breaking loop because user is not on the way');
        stopLocationTracking();
        break;
      }

      final userLocation = await getCurrentLocation();

      print(
          '############################### Service | startLocationTracking | Inside While');
      if (userLocation != null) {
        debugPrint(
            'Location start to track: ${userLocation.latitude}, ${userLocation.longitude}');

        // const proximityThresholdMeters = 100;
        //
        // final distanceToParking = Geolocator.distanceBetween(
        //   userLocation.latitude,
        //   userLocation.longitude,
        //   reservation.parking!.location.latitude,
        //   reservation.parking!.location.longitude,
        // );
        //
        // if (distanceToParking <= proximityThresholdMeters) {
        //   print(
        //       'Breaking loop because distance to parking is within threshold');
        //   break;
        // }

        print(
            '####### Location Service | Updating Location | New Location: ${userLocation.latitude}, ${userLocation.longitude},');

        await updateUserLocationInReservationDatabase(
            reservation, userLocation);
      }

      await Future.delayed(const Duration(seconds: 30));
    }
    print(
        '############################### Service | startLocationTracking completed');
  }

  void stopLocationTracking() {
    isTracking = false;
  }

  StreamSubscription<Position?> startListeningToLocationChanges(
      void Function(Position) onLocationChanged) {
    // final hasPermission = await checkLocationPermission();
    // if (!hasPermission) {
    //   final permissionGranted = await requestLocationPermission();
    //   if (!permissionGranted) {
    //     return StreamSubscription<Position?>.empty();
    //   }
    // }

    _positionStreamSubscription?.cancel();

    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 3,
      ),
    ).listen((Position position) {
      onLocationChanged(position);
    });
  }

  Future<void> updateUserLocationInReservationDatabase(
      Reservation reservation, Position position) async {
    try {
      print(
          'Location Service | updateUserLocationInReservationDatabase | Location: ${position.latitude}, ${position.longitude}');
      final locationHistory = LocationHistory(
        latitude: position.latitude,
        longitude: position.longitude,
        heading: position.heading,
        timestamp: DateTime.now(),
      );
      await _reservationRepository.updateReservationLocation(
          reservation.id!, locationHistory);
    } catch (error) {
      debugPrint('Erro ao atualizar localização no banco de dados: $error');
    }
  }

  final averageSpeedMetersPerSecond = 50.0 / 3.6;

  Future<double?> calculateEstimatedTime(
    double originLatitude,
    double originLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    final userLocation = await getCurrentLocation();

    if (userLocation != null) {
      try {
        final distanceInMeters = Geolocator.distanceBetween(
          destinationLatitude,
          destinationLongitude,
          originLatitude,
          originLongitude,
        );

        final double estimatedTimeInSeconds =
            distanceInMeters / averageSpeedMetersPerSecond;

        return estimatedTimeInSeconds;
      } catch (e) {
        debugPrint('Erro ao calcular o tempo estimado: $e');
        return null;
      }
    }
    return null;
  }
}
