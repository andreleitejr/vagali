import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/map/views/map_view.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/services/search_service.dart';
import 'package:vagali/theme/images.dart';

class MapController extends GetxController {
  final LocationService locationService = Get.find();
  final ParkingRepository _parkingRepository = Get.find();
  final SearchService _searchService = Get.find();
  GoogleMapController? googleMapController;

  final userCurrentLocation = Rx<Position?>(null);
  final nearbyParkings = <Parking>[].obs;
  final filteredParkings = <Parking>[].obs; // Adicionado
  final selectedParking = Rx<Parking?>(null);

  var markers = <Marker>{}.obs;
  late BitmapDescriptor parkingMarkerIcon;
  late BitmapDescriptor userMarkerIcon;

  var loading = false.obs;
  var searchText = ''.obs; // Adicionado

  @override
  Future<void> onInit() async {
    super.onInit();
    loading(true);
    await _loadParkingMarkers();
    await _loadUserMarker();

    userCurrentLocation.value = locationService.userLocation;

    await fetchNearbyParkings();
    _addMarkers();
    _addUserMarker();

    ever(searchText, (_) {
      updateFilteredParkings();
    });
    ever(filteredParkings, (_) {
      if (googleMapController != null && filteredParkings.isNotEmpty) {
        final location = filteredParkings.first.location;
        final currentPosition = CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 16,
        );
        googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
      }
      _addMarkers();
    });

    await Future.delayed(const Duration(seconds: 1));
    loading(false);
  }

  Future<void> loadMapStyle(GoogleMapController controller) async {
    final String styleString =
        await rootBundle.loadString('assets/map_style.json');

    controller.setMapStyle(styleString);
  }

  Future<void> _loadParkingMarkers() async {
    final Uint8List markerIconData =
        await getBytesFromAsset(Images.marker, 128);
    parkingMarkerIcon = BitmapDescriptor.fromBytes(markerIconData);
  }

  Future<void> _loadUserMarker() async {
    final Uint8List markerIconData =
        await getBytesFromAsset(Images.userMarker, 128);
    userMarkerIcon = BitmapDescriptor.fromBytes(markerIconData);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final frameInfo = await codec.getNextFrame();
    final byteData =
        await frameInfo.image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> fetchNearbyParkings() async {
    try {
      final parkings = await _parkingRepository.getParkingsWithEntities();
      parkings.sort((a, b) => a.distance.compareTo(b.distance));
      nearbyParkings.assignAll(parkings);
      updateFilteredParkings();
    } catch (error) {
      print('Error fetching nearby parkings: $error');
    }
  }

  void updateFilteredParkings() {
    filteredParkings.assignAll(_searchService.filterBySearchText<Parking>(
      nearbyParkings,
      searchText.value,
      (parking) => [
        parking.address.city,
        parking.address.state,
        parking.address.street!,
        parking.address.postalCode,
      ],
    ));
  }

  void _addUserMarker() {
    final marker = Marker(
      markerId: const MarkerId('user'),
      position: const LatLng(
        // userCurrentLocation.value!.latitude,
        // userCurrentLocation.value!.longitude,
        -23.5488823, -46.6461734,
      ),
      icon: userMarkerIcon,
    );

    markers.add(marker);
  }

  void _addMarkers() {
    markers.clear();
    for (int i = 0; i < filteredParkings.length; i++) {
      final marker = Marker(
        markerId: MarkerId('marker_$i'),
        position: LatLng(
          filteredParkings[i].location.latitude,
          filteredParkings[i].location.longitude,
        ),
        onTap: () => selectedParking(filteredParkings[i]),
        icon: parkingMarkerIcon,
        infoWindow: InfoWindow(title: '\$${filteredParkings[i].price}'),
      );
      markers.add(marker);
    }
  }
}
