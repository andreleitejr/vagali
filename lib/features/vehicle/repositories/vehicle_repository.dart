import 'package:get/get.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/utils/extensions.dart';

class VehicleRepository extends FirestoreRepository<Vehicle> {
  VehicleRepository()
      : super(
          collectionName: 'vehicles',
          fromDocument: (document) => Vehicle.fromDocument(document),
        );

  Future<List<Vehicle>?> getVehiclesFromTenant(String tenantId) async {
    try {
      final userRef = firestore.collection('users').doc(tenantId);

      final vehiclesRef = userRef.collection('vehicles');

      final document = await vehiclesRef.get();

      return document.docs.map((doc) => fromDocument(doc)).toList();
    } catch (e) {
      print('Erro ao buscar o veículo: $e');
      return null;
    }
  }
}
