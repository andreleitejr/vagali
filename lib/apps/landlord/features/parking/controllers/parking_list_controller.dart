import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/features/user/models/user.dart';

class ParkingListController extends GetxController {
  final User user = Get.find();
  final ParkingRepository _repository = Get.find();
  final parkings = <Parking>[].obs;

  @override
  Future<void> onInit() async {
    await fetchUserParkings();
    super.onInit();
  }

  Future<void> fetchUserParkings() async {
    try {
      final userParkings = await _repository.getAll(userId: user.id);
      // await fetchLandlordsForParkings(allParkings);
      userParkings.sort((b, a) => a.createdAt.compareTo(b.createdAt));
      parkings.assignAll(userParkings);
      // updateFilteredParkings();
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }
}
