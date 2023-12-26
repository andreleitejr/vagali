import 'package:get/get.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/models/parking_type.dart';

class ParkingFilterService extends GetxService {
  final selectedCategories = <ParkingType>[].obs;

  final filteredParkings = RxList<Parking>();

  List<Parking> filterParkingsByCategory(List<Parking> parkings) {
    if (selectedCategories.isEmpty) {
      return parkings;
    } else {
      parkings = parkings
          .where((parking) =>
              selectedCategories.any((type) => parking.type == type.type))
          .toList();
      return parkings;
    }
  }
}
