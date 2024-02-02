import 'package:get/get.dart';
import 'package:vagali/features/cashout/models/cashout.dart';
import 'package:vagali/features/cashout/repositories/cashout_repository.dart';
import 'package:vagali/features/user/models/user.dart';

class CashOutListController extends GetxController {
  final User user = Get.find();

  final _repository = Get.put(CashOutRepository());

}
