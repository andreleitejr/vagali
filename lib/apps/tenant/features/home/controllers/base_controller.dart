import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/home/controllers/home_controller.dart';
import 'package:vagali/features/user/models/user.dart';

class BaseController extends GetxController {

  final HomeController homeController = HomeController();
  BaseController(this.index);

  final User tenant = Get.find();

  final int? index;

  var selectedIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    if (index != null) selectedIndex(index);
  }
}
