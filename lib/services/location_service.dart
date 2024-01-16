import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/models/location_history.dart';

class LocationService {
  final ReservationRepository _reservationRepository = ReservationRepository();
  Position? _userLocation;

  Position? get userLocation => _userLocation;

  Future<void> getUserLocation() async {
    try {
      _userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // return position;
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
    final hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      final permissionGranted = await requestLocationPermission();
      if (!permissionGranted) {
        return;
      }
    }

    isTracking = true;

    while (isTracking) {
      if (!reservation.isUserOnTheWay) {
        break;
      }

      if (userLocation != null) {
        const proximityThresholdMeters = 100;

        final distanceToParking = Geolocator.distanceBetween(
          userLocation!.latitude,
          userLocation!.longitude,
          reservation.parking!.location.latitude,
          reservation.parking!.location.longitude,
        );

        if (distanceToParking <= proximityThresholdMeters) {
          break;
        }

        await updateUserLocationInReservationDatabase(
            reservation, userLocation!);
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void stopLocationTracking() {
    isTracking = false;
  }

  Future<void> updateUserLocationInReservationDatabase(
      Reservation reservation, Position position) async {
    try {
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
  ) async {
    await getUserLocation();

    try {
      final distanceInMeters = Geolocator.distanceBetween(
        _userLocation!.latitude,
        _userLocation!.longitude,
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
}
