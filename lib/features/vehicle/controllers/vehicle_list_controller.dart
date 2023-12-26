import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';

class VehicleListController extends GetxController {
  final List<Vehicle> vehicles = Get.find(tag: 'vehicles');
}
