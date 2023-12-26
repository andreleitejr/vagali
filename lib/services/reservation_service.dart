import 'dart:async';

import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/services/location_service.dart';

/// VERIFICAR DE REMOVER E ENVIAR PRO REPO
class ReservationService extends GetxService {
  final _reservationRepository = Get.put(ReservationRepository());
  final LocationService locationService = Get.find();

  Future<Reservation?> fetchReservationById(String reservationId) async {
    try {
      return await _reservationRepository
          .getReservationWithEntities(reservationId);
    } catch (error) {
      print('Error fetching reservation with entities: $error');
      return null;
    }
  }

  void startLocationUpdates(String reservationId) {
    // Execute a atualização da localização em um loop (por exemplo, a cada minuto)
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      // Verifique se a reserva ainda precisa ser atualizada (opcional)
      // ...

      // Obtenha a localização atual do usuário
      final userLocation = locationService.userLocation;
      if (userLocation != null) {
        // Obtenha latitude e longitude da localização
        final latitude = userLocation.latitude;
        final longitude = userLocation.longitude;

        // Atualize a localização da reserva
      }
    });
  }
}
