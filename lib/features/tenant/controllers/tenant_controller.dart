import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/models/image_blurhash.dart';

class TenantController extends GetxController {
  final Tenant tenant = Get.find();
  final _vehicleRepository = Get.find<VehicleRepository>();

  final vehicles = <Vehicle>[].obs;

  String get name => tenant.firstName;

  ImageBlurHash get image => tenant.image;
  final loading = false.obs;

  Future<void> fetchVehicles() async {
    try {
      final vehicles =
          await _vehicleRepository.getVehiclesFromTenant(tenant.id!);

      if (vehicles != null) {
        this.vehicles.addAll(vehicles);
        Get.put<List<Vehicle>>(vehicles, tag: 'vehicles');
        debugPrint('Successful got vehicles for Tenant.');
      }
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  ImageBlurHash get vehicleImage => vehicles.first.image;

  @override
  Future<void> onInit() async {
    loading(true);
    await fetchVehicles();
    loading(false);
    super.onInit();
  }
}
