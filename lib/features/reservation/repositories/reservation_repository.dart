import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/tenant/repositories/tenant_repository.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/utils/extensions.dart';

class ReservationRepository extends FirestoreRepository<Reservation> {
  ReservationRepository()
      : super(
          collectionName: 'reservations',
          fromDocument: (document) => Reservation.fromDocument(document),
        );

  @override
  Stream<List<Reservation>> streamAll() {
    try {
      final Tenant tenant = Get.find();

      final collection = firestore.collection(collectionName);

      final query = collection.where('tenantId', isEqualTo: tenant.id);

      final stream = query.snapshots().map((querySnapshot) =>
          querySnapshot.docs.map((doc) => fromDocument(doc)).toList());

      return stream;
    } catch (error) {
      print('Error streaming data from $collectionName in Firestore: $error');
      return Stream.value([]);
    }
  }
  @override
  Stream<List<Reservation>> streamAllReservationsForLandlord() {
    try {
      final Landlord landlord = Get.find();

      final collection = firestore.collection(collectionName);

      final query = collection.where('landlordId', isEqualTo: landlord.id);

      final stream = query.snapshots().map((querySnapshot) =>
          querySnapshot.docs.map((doc) => fromDocument(doc)).toList());

      return stream;
    } catch (error) {
      print('Error streaming data from $collectionName in Firestore: $error');
      return Stream.value([]);
    }
  }

  /// MODIFICAR
  Future<List<Reservation>> fetchReservationsForUser(String userId) async {
    try {
      var reservations = await getGroup();

      reservations = reservations
          .where((reservation) =>
              reservation.landlordId == userId ||
              reservation.tenantId == userId)
          .toList();

      for (var i = 0; i < reservations.length; i++) {
        final reservation = reservations[i];
        final reservationWithEntities =
            await getReservationWithEntities(reservation.id!);

        reservations[i] = reservationWithEntities;
      }

      return reservations;
    } catch (error) {
      print('Error fetching reservations: $error');
      return [];
    }
  }

  Future<Reservation> getReservationWithEntities(String reservationId) async {
    try {
      final document =
          await firestore.collection(collectionName).doc(reservationId).get();
      final reservation = fromDocument(document);
      final landlord = await LandlordRepository().get(reservation.landlordId);
      final tenant = await TenantRepository().get(reservation.tenantId);
      final parkings = await ParkingRepository().getGroup();
      final vehicles = await VehicleRepository().getGroup();

      reservation.landlord = landlord as Landlord;
      reservation.tenant = tenant as Tenant;
      reservation.parking = parkings
          .firstWhereOrNull((parking) => parking.id == reservation.parkingId);
      reservation.vehicle = vehicles
          .firstWhereOrNull((vehicle) => vehicle.id == reservation.vehicleId);

      return reservation;
    } catch (error) {
      print('Error fetching reservation with entities: $error');
      throw error;
    }
  }

  Future<void> updateReservationLocation(
      String reservationId, LocationHistory locationHistory) async {
    try {
      await firestore.collection(collectionName).doc(reservationId).update({
        'locationHistory': FieldValue.arrayUnion([locationHistory.toMap()]),
      });
    } catch (error) {
      print('Erro ao atualizar a localização da reserva: $error');
      throw error;
    }
  }

  Future<void> updateReservationStatus(
      String reservationId, ReservationStatus newStatus) async {
    try {
      await firestore.collection(collectionName).doc(reservationId).update({
        'status': newStatus.toStringSimplified(),
      });
    } catch (error) {
      print('Erro ao atualizar o status da reserva: $error');
      throw error;
    }
  }
}
