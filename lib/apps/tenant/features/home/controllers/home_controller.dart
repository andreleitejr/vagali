import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_tag.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/services/search_service.dart';

class HomeController extends GetxController {
  final User tenant = Get.find();
  final _parkingRepository = Get.put(ParkingRepository());

  // final _reservationRepository = Get.put(ReservationRepository());

  final locationService = Get.put(LocationService());

  final _searchService = Get.put(SearchService());

  final nearbyParkings = <Parking>[].obs;

  final loading = false.obs;

  // final showItemSelection = false.obs;

  // final searchText = ''.obs;
  //
  // String get cleanText => searchText.value.clean;

  final category = ParkingTag.all.obs;

  final filteredParkings = RxList<Parking>();

  @override
  Future<void> onInit() async {
    super.onInit();
    loading(true);
    await locationService.requestLocationPermission();
    await fetchNearbyParkings();
    //
    // await fetchReservations();
    filteredParkings.value = nearbyParkings;
    loading(false);
    ever(category, (_) {
      filteredParkings(filterParkingsByCategory(nearbyParkings));
    });
  }

  Future<void> fetchNearbyParkings() async {
    try {
      final parkings = await _parkingRepository.getGroup();

      parkings.sort((a, b) => a.distance.compareTo(b.distance));

      nearbyParkings.assignAll(parkings);

      Get.put<List<Parking>>(nearbyParkings, tag: 'nearbyParkings');
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  // List<Parking> filterParkingsBySearchText() {
  //   return _searchService.filterBySearchText<Parking>(
  //     nearbyParkings,
  //     searchText.value,
  //     (parking) => [
  //       parking.address.city,
  //       parking.address.state,
  //       parking.address.street,
  //       parking.address.postalCode,
  //     ],
  //   );
  // }

  List<Parking> filterParkingsByCategory(List<Parking> parkings) {
    if (category.value == ParkingTag.all) {
      return parkings;
    } else {
      parkings = parkings
          .where((parking) => parking.tags.contains(category.value))
          .toList();
      return parkings;
    }
  }
}
