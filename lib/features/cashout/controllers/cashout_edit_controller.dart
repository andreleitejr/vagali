import 'package:get/get.dart';
import 'package:vagali/features/cashout/models/cashout.dart';
import 'package:vagali/features/cashout/repositories/cashout_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class CashOutController extends GetxController {
  final User user = Get.find();

  final _repository = Get.put(CashOutRepository());

  final loading = false.obs;

  final cashOuts = <CashOut>[].obs;

  @override
  void onInit() {
    _listenToCashOutStream();
    super.onInit();
  }

  void _listenToCashOutStream() {
    _repository.streamAll(userId: user.id!).listen((dataList) {
      cashOuts(dataList);
    });
  }

  Future<SaveResult> save(double amount) async {
    loading(true);

    final cashOut = CashOut(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: user.id!,
      amount: amount,
      status: CashOutStatus.pending,
    );

    final result = await _repository.save(cashOut);

    loading(false);
    return result;
  }
}
