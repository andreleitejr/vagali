import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/apps/landlord/repositories/landlord_repository.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/services/search_service.dart';
import 'package:vagali/theme/images.dart';

class MapController extends GetxController {
  final LocationService _locationService = Get.find();
  final ParkingRepository _parkingRepository = Get.find();
  final LandlordRepository _landlordRepository = Get.find();
  final SearchService _searchService = Get.find();
  GoogleMapController? googleMapController;

  final userCurrentLocation = Rx<Position?>(null);
  final nearbyParkings = <Parking>[].obs;
  final filteredParkings = <Parking>[].obs;
  final selectedParking = Rx<Parking?>(null);

  var markers = <Marker>{}.obs;
  late BitmapDescriptor parkingMarkerIcon;
  late BitmapDescriptor userMarkerIcon;

  var loading = false.obs;
  var searchText = ''.obs;

  late StreamSubscription<Position?> _locationSubscription;
  Marker? userMarker;

  @override
  Future<void> onInit() async {
    super.onInit();
    loading(true);

    await fetchNearbyParkings();
    await _loadParkingMarkers();
    await _loadUserMarker();

    // _addUserMarker();
    _addMarkers();

    _locationSubscription =
        _locationService.startListeningToLocationChanges((position) {
      userCurrentLocation.value = position;

      _updateUserMarker();
      loading(false);
    });

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
  }

  @override
  void onClose() {
    // Cancela a escuta contínua da localização ao fechar o controller
    _locationSubscription.cancel();

    super.onClose();
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
      final allParkings = await _parkingRepository.getAll();
      await fetchLandlordsForParkings(allParkings);
      allParkings.sort((a, b) => a.distance.compareTo(b.distance));
      nearbyParkings.assignAll(allParkings);
      updateFilteredParkings();
    } catch (error) {
      print('Error fetching nearby parkings: $error');
    }
  }

  Future<void> fetchLandlordsForParkings(List<Parking> parkings) async {
    for (var parking in parkings) {
      final landlord = await getLandlord(parking.userId);
      parking.owner = landlord;
    }
  }

  Future<Landlord?> getLandlord(String userId) async {
    final landlord = await _landlordRepository.get(userId);
    return landlord;
  }

  void updateFilteredParkings() {
    filteredParkings.assignAll(
      _searchService.filterBySearchText<Parking>(
        nearbyParkings,
        searchText.value,
        (parking) => [
          parking.address.city,
          parking.address.state,
          parking.address.street,
          parking.address.postalCode,
        ],
      ),
    );
  }

  void _addUserMarker() {
    final marker = Marker(
      markerId: const MarkerId('user'),
      position: LatLng(
        userCurrentLocation.value!.latitude,
        userCurrentLocation.value!.longitude,
      ),
      icon: userMarkerIcon,
    );

    markers.add(marker);
  }

  void _updateUserMarker() {
    markers.remove(userMarker);
    _addUserMarker();
    final currentPosition = CameraPosition(
      target: LatLng(userCurrentLocation.value!.latitude,
          userCurrentLocation.value!.longitude),
      zoom: 16,
    );
    googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
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
