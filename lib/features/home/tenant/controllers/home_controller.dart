import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_type.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/apps/tenant/features/home/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/services/search_service.dart';
import 'package:vagali/utils/extensions.dart';

class HomeController extends GetxController {
  final User tenant = Get.find();
  final _parkingRepository = Get.put(ParkingRepository());

  // final _reservationRepository = Get.put(ReservationRepository());

  final locationService = Get.put(LocationService());

  final _searchService = Get.put(SearchService());

  final nearbyParkings = <Parking>[].obs;

  final loading = false.obs;

  final searchText = ''.obs;

  String get cleanText => searchText.value.clean;

  final selectedCategories = <String>[parkingTypes.first.type].obs;

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
    ever(selectedCategories, (_) {
      filteredParkings(filterParkingsByCategory(nearbyParkings));
    });
    ever(searchText, (_) {
      filteredParkings(filterParkingsBySearchText());
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

  List<Parking> filterParkingsBySearchText() {
    return _searchService.filterBySearchText<Parking>(
      nearbyParkings,
      searchText.value,
      (parking) => [
        parking.address.city,
        parking.address.state,
        parking.address.street,
        parking.address.postalCode,
      ],
    );
  }

  List<Parking> filterParkingsByCategory(List<Parking> parkings) {
    if (selectedCategories.isEmpty ||
        selectedCategories.any(
          (type) => type == ParkingType.all,
        )) {
      return parkings;
    } else {
      parkings = parkings
          .where((parking) =>
              selectedCategories.any((type) => parking.type == type))
          .toList();
      return parkings;
    }
  }
}
