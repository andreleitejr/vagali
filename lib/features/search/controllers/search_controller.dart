// item_search_controller.dart

import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/models/dimension.dart';


/// IMPLEMENTAR O SEARCH POSTERIORMENTE NA VERSAO 1.0.1

class SearchParkingController extends GetxController {
  final selectedItemType = Rx<ItemType?>(null);
  final selectedVehicleType = Rx<VehicleType?>(null);
  final width = ''.obs;
  final height = ''.obs;
  final depth = ''.obs;

  Dimension get dimension => Dimension(
        width: double.parse(width.value),
        height: double.parse(height.value),
        depth: double.parse(depth.value),
      );

  final selectedLocation = ''.obs;
  final selectedCheckInDate = Rx<DateTime?>(null);
  final selectedCheckOutDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(selectedItemType, (_) {
      selectedVehicleType.value = null;
    });
  }

  void saveReservation() {
    // Implement the logic to save the reservation
    // You can access the selected values using: selectedItemType.value, selectedVehicleType.value, etc.
  }
}
