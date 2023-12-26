import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';

class LandlordRepository extends UserRepository {

  @override
  Future<List<Landlord>> getAll({String? userId}) async {
    try {
      final query = firestore.collection(collectionName).where(
            'type',
            isEqualTo: UserType.landlord,
          );

      final querySnapshot = await query.get();

      final users = querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

      final landlords = <Landlord>[];

      for (final user in users) {
        landlords.add(Landlord.fromUser(user));
      }
      return landlords;
    } catch (error) {
      print(
          'Error fetching all Landlords data from $collectionName in Firestore: $error');
      return [];
    }
  }

  Future<List<Parking>> getLandlordParkings() async {
    try {

      final ParkingRepository _parkingRepository = ParkingRepository();

      final List<Parking> parkings = await _parkingRepository.getAll();

      final Landlord landlord = Get.find<Landlord>();
      landlord.parkings.addAll(parkings);
      print('Parkings atualizados com sucesso para o Landlord.');

      Get.put<List<Parking>>(landlord.parkings, tag: 'landlordParkings');
      return landlord.parkings;
    } catch (error) {
      print('Erro ao atualizar parkings: $error');
      return [];
    }
  }
}
