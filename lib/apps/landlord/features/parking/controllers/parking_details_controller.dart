import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';

class ParkingDetailsController extends GetxController {
  final Rx<Parking?> parking = Rx<Parking?>(null);

  final carouselController = CarouselController();
  var currentCarouselImage = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
