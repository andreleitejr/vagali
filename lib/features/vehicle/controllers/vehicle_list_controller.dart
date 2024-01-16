import 'package:get/get.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';

class VehicleListController extends GetxController {
  final List<Vehicle> vehicles = Get.find(tag: 'vehicles');
}
