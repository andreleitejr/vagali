import 'package:get/get.dart';
import 'package:vagali/features/tenant/models/tenant.dart';

class BaseController extends GetxController {
  BaseController(this.index);

  final Tenant tenant = Get.find();

  final int? index;

  var selectedIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    if (index != null) selectedIndex(index);
  }
}
