import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/models/image_blurhash.dart';

class LandlordController extends GetxController {
  final Landlord landlord = Get.find();
  final _parkingRepository = Get.put(ParkingRepository());

  final parkings = <Parking>[].obs;

  String get name => landlord.firstName;

  ImageBlurHash get image => landlord.image;
  final loading = false.obs;

  Future<void> fetchVehicles() async {
    try {
      final parkingsWithEntities =
          await _parkingRepository.getParkingsWithEntities();
      parkings.addAll(parkingsWithEntities);
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  ImageBlurHash get parkingImage => parkings.first.images.first;

  @override
  Future<void> onInit() async {
    loading(true);
    await fetchVehicles();
    loading(false);
    super.onInit();
  }
}
