import 'package:get/get.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';

class TenantRepository extends UserRepository {

  // Future<void> getTenantVehicles() async {
  //   try {
  //     final _vehicleRepository = VehicleRepository();
  //     final List<Vehicle> vehicles = await _vehicleRepository.getAll();
  //
  //     final Tenant tenant = Get.find<Tenant>();
  //     tenant.vehicles.addAll(vehicles);
  //
  //     Get.put<List<Vehicle>>(tenant.vehicles, tag: 'tenantVehicles');
  //     print('Veículos atualizados com sucesso para o usuário.');
  //   } catch (error) {
  //     print('Erro ao atualizar veículos: $error');
  //   }
  // }

  @override
  Future<List<Tenant>> getAll({String? userId}) async {
    try {
      final query = firestore.collection(collectionName).where(
            'type',
            isEqualTo: UserType.tenant,
          );

      final querySnapshot = await query.get();

      final users = querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

      final tenants = <Tenant>[];

      for (final user in users) {
        tenants.add(Tenant.fromUser(user));
      }
      return tenants;
    } catch (error) {
      print(
          'Error fetching all Landlords data from $collectionName in Firestore: $error');
      return [];
    }
  }
}
