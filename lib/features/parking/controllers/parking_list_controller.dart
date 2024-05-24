import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/user/models/user.dart';

class ParkingListController extends GetxController {
  final User user = Get.find();
  final ParkingRepository _repository = Get.find();
  final parkings = <Parking>[].obs;

  @override
  Future<void> onInit() async {
    streamParking();
    super.onInit();
  }

  void streamParking() {
    _repository.streamAll(userId: user.id).listen((dataList) {
      parkings.assignAll(dataList);
      parkings.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    });
  }
}
