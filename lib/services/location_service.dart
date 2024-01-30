import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
      if (!await Geolocator.isLocationServiceEnabled()) {
        print('Serviço de localização desativado.');
        return null;
      }

      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final LocationPermission permission =
            await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          print('Permissões de localização não concedidas.');
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      return position;
    } catch (e) {
      print('Erro ao obter a localização: $e');
      return null;
    }
  }

  Future<double> _getHeadingFromGyroscope() async {
    try {
      final gyroscopeEvents =
          gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval);
      await for (GyroscopeEvent event in gyroscopeEvents) {
        // Use o valor do eixo Z como heading
        double rawHeading = event.z;

        // Normaliza o valor para a escala de 0 a 360 graus
        double heading = (rawHeading + 1.0) * 180.0;

        print('Heading from Gyroscope: $heading');
        return heading;
      }
      return 0.0; // Valor padrão se não conseguir obter do giroscópio
    } catch (e) {
      print('Erro ao obter heading do giroscópio: $e');
      return 0.0; // Valor padrão em caso de erro
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
    isTracking = true;
    while (isTracking) {
      if (!reservation.isUserOnTheWay) {
        break;
      }

      final userLocation = await getCurrentLocation();

      if (userLocation != null) {
        debugPrint(
            'Location start to track: ${userLocation.latitude}, ${userLocation.longitude}');

        const proximityThresholdMeters = 100;

        final distanceToParking = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          reservation.parking!.location.latitude,
          reservation.parking!.location.longitude,
        );

        if (distanceToParking <= proximityThresholdMeters) {
          print(
              'Breaking loop because distance to parking is within threshold');
          break;
        }

        await updateUserLocationInReservationDatabase(
            reservation, userLocation);
      }

      /// Tempo de update da localização
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  void stopLocationTracking() {
    print('Location Service | Stopping Tracking Location');
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
        accuracy: LocationAccuracy.bestForNavigation,
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
          'Location Service | updateUserLocationInReservationDatabase | Location: ${position.heading} - ${position.latitude}, ${position.longitude}');
      final locationHistory = LocationHistory(
        latitude: position.latitude,
        longitude: position.longitude,
        heading: await _getHeadingFromGyroscope(),
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

  Future<double> getDistanceFromUserLocation(Position position) async {
    final userLocation = await getCurrentLocation();

    if (userLocation != null) {
      return _calculateDistance(userLocation, position);
    } else {
      return 0.0;
    }
  }

  double _calculateDistance(Position origin, Position destination) {
    return Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
  }
}
