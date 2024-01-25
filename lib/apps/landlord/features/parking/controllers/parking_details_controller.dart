import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';

class ParkingDetailsController extends GetxController {
  // final ParkingRepository _repository = Get.find();
  final Parking _parking;
  final Rx<Parking?> parking = Rx<Parking?>(null);

  final carouselController = CarouselController();
  var currentCarouselImage = 0.obs;

  @override
  Future<void> onInit() async {
    // await _loadOwnerDetails();
    super.onInit();
  }

  ParkingDetailsController(this._parking);

  // Future<void> _loadOwnerDetails() async {
  //   parking.value = await _repository.get(parking.value.id!);
  // }
}
