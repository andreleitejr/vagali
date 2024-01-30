import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/apps/landlord/repositories/landlord_repository.dart';
import 'package:vagali/apps/tenant/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/apps/tenant/models/tenant.dart';
import 'package:vagali/apps/tenant/repositories/tenant_repository.dart';
import 'package:vagali/features/item/repositories/item_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/flavor_config.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/utils/extensions.dart';

class ReservationRepository extends FirestoreRepository<Reservation> {
  ReservationRepository()
      : super(
          collectionName: 'reservations',
          fromDocument: (document) => Reservation.fromDocument(document),
        );

  // Stream<List<Reservation>> getRealtimeReservationsForUser(String userId) {
  //   try {
  //     // Consulta as reservas do usuário em tempo real
  //     return _firestore
  //         .collection('reservations')
  //         .where('tenantId', isEqualTo: userId)
  //         .snapshots()
  //         .map((QuerySnapshot reservationQuery) {
  //       // Mapeia os documentos da consulta para objetos de Reserva
  //       return reservationQuery.docs
  //           .map((QueryDocumentSnapshot reservationDoc) {
  //         Reservation reservation = Reservation.fromSnapshot(reservationDoc);
  //
  //         // Busca informações em tempo real para o landlord
  //         DocumentReference landlordRef =
  //             _firestore.collection('landlords').doc(reservation.landlordId);
  //         reservation.landlordRef = landlordRef;
  //
  //         // Busca informações em tempo real para o parking
  //         DocumentReference parkingRef =
  //             _firestore.collection('parkings').doc(reservation.parkingId);
  //         reservation.parkingRef = parkingRef;
  //
  //         // Busca informações em tempo real para o item
  //         DocumentReference itemRef =
  //             _firestore.collection('items').doc(reservation.itemId);
  //         reservation.itemRef = itemRef;
  //
  //         return reservation;
  //       }).toList();
  //     });
  //   } catch (error) {
  //     print('Erro ao buscar reservas em tempo real: $error');
  //     return Stream.value([]);
  //   }
  // }

  // @override
  // Stream<List<Reservation>> streamAll() {
  //   try {
  //     final User user = Get.find();
  //
  //     final collection = firestore.collection(collectionName);
  //
  //     final query = collection.where(
  //         Get.find<FlavorConfig>().flavor == Flavor.tenant
  //             ? 'tenantId'
  //             : 'landlordId',
  //         isEqualTo: user.id);
  //
  //     final stream = query.snapshots().map((querySnapshot) =>
  //         querySnapshot.docs.map((doc) => fromDocument(doc)).toList());
  //
  //     return stream;
  //   } catch (error) {
  //     print('Error streaming data from $collectionName in Firestore: $error');
  //     return Stream.value([]);
  //   }
  // }

  final _landlordRepository = Get.put(LandlordRepository());
  final  _tenantRepository = Get.put(TenantRepository());
  final  _parkingRepository = Get.put(ParkingRepository());
  final  _itemRepository =  Get.put(ItemRepository());

  @override
  Stream<List<Reservation>> streamAll() {
    try {
      final User user = Get.find();

      final collection = firestore.collection(collectionName);

      final query = collection.where(
          Get.find<FlavorConfig>().flavor == Flavor.tenant
              ? 'tenantId'
              : 'landlordId',
          isEqualTo: user.id);

      final stream = query.snapshots().asyncMap((querySnapshot) async {
        final List<Reservation> reservations = [];

        await Future.wait(querySnapshot.docs.map((doc) async {
          final reservation = fromDocument(doc);

          final tenant = Get.find<FlavorConfig>().flavor == Flavor.tenant
              ? user as Tenant
              : await _tenantRepository.get(reservation.tenantId);
          reservation.tenant = tenant;

          final landlord = Get.find<FlavorConfig>().flavor == Flavor.landlord
              ? user as Landlord
              : await _landlordRepository.get(reservation.landlordId);
          reservation.landlord = landlord;

          final parking = await _parkingRepository.get(reservation.parkingId);
          reservation.parking = parking;

          final item = await _itemRepository.get(reservation.itemId);
          reservation.item = item;

          reservations.add(reservation);
        }));

        return reservations;
      });

      return stream;
    } catch (error) {
      print('Error streaming data from Reservations in Firestore: $error');
      return Stream.value([]);
    }
  }

  Stream<List<Reservation>> streamAllReservationsForLandlord() {
    try {
      final User landlord = Get.find();

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
      // final vehicles = await VehicleRepository().getGroup();

      reservation.landlord = landlord as Landlord;
      reservation.tenant = tenant as Tenant;
      reservation.parking = parkings
          .firstWhereOrNull((parking) => parking.id == reservation.parkingId);
      // reservation.item = vehicles
      //     .firstWhereOrNull((vehicle) => vehicle.id == reservation.itemId);

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
