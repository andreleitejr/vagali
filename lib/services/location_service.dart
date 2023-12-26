import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/services/reservation_service.dart';

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
// Variável para rastreamento ativo
  bool isTracking = false;

// Função para iniciar o rastreamento e atualizar o banco de dados
  Future<void> startLocationTracking(Reservation reservation) async {
    // Verifique as permissões de localização
    final hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      // Solicite permissão de localização se não estiver concedida
      final permissionGranted = await requestLocationPermission();
      if (!permissionGranted) {
        // Trate o caso em que a permissão foi negada pelo usuário
        return;
      }
    }

    // Defina o rastreamento como ativo
    isTracking = true;

    // Inicie o rastreamento de localização em um loop
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

        // Atualize o banco de dados com a localização do usuário
        await updateUserLocationInReservationDatabase(
            reservation, userLocation!);
      }

      // Espere um tempo antes de obter a próxima atualização de localização
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
      print(
          'Atualizando localização no banco de dados - Lat: ${position.latitude}, Lon: ${position.longitude}');
    } catch (error) {
      print('Erro ao atualizar localização no banco de dados: $error');
    }
  }

  final averageSpeedMetersPerSecond = 50.0 / 3.6;

  Future<double?> calculateEstimatedTime(
    double originLatitude,
    double originLongitude,
  ) async {
    try {
      final distanceInMeters = Geolocator.distanceBetween(
        _userLocation!.latitude,
        _userLocation!.longitude,
        originLatitude,
        originLongitude,
      );

      print('MY SUPER MAPA SHDASDAASDUHS ${distanceInMeters}');
      print('MY SUPER MAPA SHDASDAASDUsaHS ${distanceInMeters}');
      print('MY SUPER MAPA SHDASDAAsaSDUHS ${distanceInMeters}');
      print('MY SUPER MAPA SHDASDAAsaSDUHS ${distanceInMeters}');
      final double estimatedTimeInSeconds =
          distanceInMeters / averageSpeedMetersPerSecond;

      return estimatedTimeInSeconds;
    } catch (e) {
      print('Erro ao calcular o tempo estimado: $e');
      return null;
    }
  }
}
