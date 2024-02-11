import 'dart:async';
import 'dart:ui';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
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
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

class MapController extends GetxController {
  final LocationService _locationService = Get.find();
  final ParkingRepository _parkingRepository = Get.find();
  final _landlordRepository = Get.put(LandlordRepository());
  final SearchService _searchService = Get.find();
  GoogleMapController? googleMapController;

  final userCurrentLocation = Rx<Position?>(null);
  final nearbyParkings = <Parking>[].obs;

  // final filteredParkings = <Parking>[].obs;
  final selectedParking = Rx<Parking?>(null);

  var markers = <Marker>{}.obs;
  late BitmapDescriptor parkingMarkerIcon;
  late BitmapDescriptor userMarkerIcon;

  var loading = false.obs;

  // var searchText = ''.obs;
  final zoom = 16.toDouble().obs;

  late StreamSubscription<Position?> _locationSubscription;
  Marker? userMarker;

  @override
  Future<void> onInit() async {
    super.onInit();
    loading(true);

    _loadUserMarker();
    await fetchNearbyParkings();

    await Future.delayed(const Duration(seconds: 1));
    // _addUserMarker();
    _addMarkers();

    _locationSubscription =
        _locationService.startListeningToLocationChanges((position) {
      userCurrentLocation.value = position;

      _updateUserMarker();

      if (googleMapController != null) {
        final currentPosition = LatLng(
          userCurrentLocation.value!.latitude,
          userCurrentLocation.value!.longitude,
        );
        googleMapController!
            .animateCamera(CameraUpdate.newLatLng(currentPosition));
      }
      loading(false);
    });

    // ever(searchText, (_) {
    //   updateFilteredParkings();
    // });

    // ever(filteredParkings, (_) {
    //   if (googleMapController != null && filteredParkings.isNotEmpty) {
    //     final location = filteredParkings.first.location;
    //     final currentPosition = CameraPosition(
    //       target: LatLng(location.latitude, location.longitude),
    //       zoom: 16,
    //     );
    //     googleMapController!
    //         .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    //   }
    //   _addMarkers();
    // });

    // await Future.delayed(const Duration(seconds: 1));
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

  Future<BitmapDescriptor> _loadParkingMarkers(String title) async {
    final Uint8List markerIconData = await getBytesFromCanvas(title);
    return BitmapDescriptor.fromBytes(markerIconData);
  }

  Future<void> _loadUserMarker() async {
    final Uint8List markerIconData =
        await getBytesFromAsset(Images.userMarker, 64);
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

  Future<Uint8List> getBytesFromCanvas(String title) async {
    final width = 100.0;
    final height = 125.0;

    ByteData? data = await rootBundle.load(Images.marker);
    final bytes = data.buffer.asUint8List();

    final codec = await instantiateImageCodec(bytes,
        targetWidth: width.toInt(), targetHeight: height.toInt());
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    canvas.drawImage(image, Offset(0.0, 0.0), Paint());

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);

    painter.text = TextSpan(
      text: title,
      style: ThemeTypography.semiBold32,
    );
    painter.layout();

    painter.paint(
      canvas,
      Offset(
        (width * 0.5) - painter.width * 0.5,
        height - ((height / 2) + 28),
      ),
    );

    final img = await pictureRecorder.endRecording().toImage(
        width.toInt(), (height * 1.5).toInt());

    data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<void> fetchNearbyParkings() async {
    try {
      final allParkings = await _parkingRepository.getAll();
      // await fetchLandlordsForParkings(allParkings);
      allParkings.sort((a, b) => a.distance.compareTo(b.distance));
      nearbyParkings.assignAll(allParkings);
      // updateFilteredParkings();
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
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

  // void updateFilteredParkings() {
  //   filteredParkings.assignAll(
  //     _searchService.filterBySearchText<Parking>(
  //       nearbyParkings,
  //       searchText.value,
  //       (parking) => [
  //         parking.address.city,
  //         parking.address.state,
  //         parking.address.street,
  //         parking.address.postalCode,
  //       ],
  //     ),
  //   );
  // }

  void _addUserMarker() {
    userMarker = Marker(
      markerId: const MarkerId('user'),
      position: LatLng(
        userCurrentLocation.value!.latitude,
        userCurrentLocation.value!.longitude,
      ),
      icon: userMarkerIcon,
    );

    markers.add(userMarker!);
  }

  void _updateUserMarker() {
    markers.remove(userMarker);
    _addUserMarker();
  }

  Future<void> _addMarkers() async {
    markers.clear();
    for (int i = 0; i < nearbyParkings.length; i++) {
      final title = 'R\$${nearbyParkings[i].price.hour!}';
      final icon = await _loadParkingMarkers(title);

      final marker = Marker(
        markerId: MarkerId('marker_$i'),
        position: LatLng(
          nearbyParkings[i].location.latitude,
          nearbyParkings[i].location.longitude,
        ),
        onTap: () => selectedParking(nearbyParkings[i]),
        icon: icon,
        // infoWindow: InfoWindow(title: '\$${UtilBrasilFields.obterReal(nearbyParkings[i].price.hour!.toDouble())}'),
      );
      markers.add(marker);
    }
  }
}
