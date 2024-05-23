import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/services/search_service.dart';
import 'package:vagali/utils/extensions.dart';

class HomeController extends GetxController {
  final User tenant = Get.find();
  final _parkingRepository = Get.put(ParkingRepository());

  // final _reservationRepository = Get.put(ReservationRepository());

  final _locationService = Get.put(LocationService());

  final _searchService = Get.put(SearchService());

  Position? currentLocation;
  final nearbyParkings = <Parking>[].obs;

  final loading = false.obs;

  // final showItemSelection = false.obs;

  final searchText = ''.obs;

  String get cleanText => searchText.value.clean;

  final category =
      Rx<ParkingTag>(parkingTags.firstWhere((t) => t.tag == ParkingTag.all));

  final filteredParkings = RxList<Parking>();

  @override
  Future<void> onInit() async {
    super.onInit();
    loading(true);
    await _locationService.requestLocationPermission();
    currentLocation = await _locationService.getCurrentLocation();
    await Future.delayed(const Duration(milliseconds: 500));
    await fetchNearbyParkings();
    //
    // await fetchReservations();
    filteredParkings.value = nearbyParkings;
    ever(searchText, (_) {
      filteredParkings(filterParkingsBySearchText());
    });
    ever(category, (_) {
      filteredParkings(filterParkingsByCategory(nearbyParkings));
    });
    loading(false);
  }

  Future<void> fetchNearbyParkings() async {
    try {
      final parkings = await _parkingRepository.getAll();

      // Calcular a distância do usuário para cada estacionamento
      if (currentLocation != null) {
        for (var parking in parkings) {
          parking.distance = await _locationService.getDistanceFromUserLocation(
            currentLocation!,
            Position(
              latitude: parking.location.latitude,
              longitude: parking.location.longitude,
              accuracy: 0.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              timestamp: DateTime.now(),
            ),
          );
        }

        parkings.sort((a, b) => a.distance.compareTo(b.distance));
      }

      nearbyParkings.assignAll(parkings);
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  List<Parking> filterParkingsBySearchText() {
    return _searchService.filterBySearchText<Parking>(
      nearbyParkings,
      searchText.value,
      (parking) => [
        parking.address.street,
        parking.address.county,
        parking.address.city,
        parking.address.state,
        parking.address.postalCode,
      ],
    );
  }

  List<Parking> filterParkingsByCategory(List<Parking> parkings) {
    if (category.value.tag == ParkingTag.all) {
      return parkings;
    } else {
      parkings = parkings
          .where((parking) =>
              parking.tags.any((tag) => tag.tag == category.value.tag))
          .toList();
      return parkings;
    }
  }
}
