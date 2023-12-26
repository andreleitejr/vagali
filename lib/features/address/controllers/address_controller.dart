import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/services/address_service.dart';
import 'package:vagali/theme/images.dart';

class AddressController extends GetxController {
  final Address address;

  final AddressService _addressService = AddressService();

  final Rx<GeoPoint?> coordinates = Rx<GeoPoint?>(null);
  late BitmapDescriptor parkingMarkerIcon;

  final marker = Rx<Marker?>(null);

  AddressController(this.address);

  Future<void> getCoordinatesFromAddress(Address address) async {
    final newCoordinates =
        await _addressService.getCoordinatesFromAddress(address);
    if (newCoordinates != null) {
      coordinates.value = newCoordinates;
    }
  }

  Future<void> loadMapStyle(GoogleMapController controller) async {
    final String styleString =
        await rootBundle.loadString('assets/map_style.json');

    controller.setMapStyle(styleString);
  }

  Future<void> _loadParkingMarker() async {
    final Uint8List markerIconData =
        await getBytesFromAsset(Images.marker, 128);
    parkingMarkerIcon = BitmapDescriptor.fromBytes(markerIconData);
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

  void _addMarkers() {
    marker.value = Marker(
      markerId: MarkerId('marker'),
      position: LatLng(
        coordinates.value!.latitude,
        coordinates.value!.longitude,
      ),
      icon: parkingMarkerIcon,
    );
  }

  @override
  Future<void> onInit() async {
    await _loadParkingMarker();
    await getCoordinatesFromAddress(address);
    _addMarkers();
    super.onInit();
  }
}
