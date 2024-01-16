import 'package:get/get.dart';
import 'package:vagali/features/support/models/support.dart';
import 'package:vagali/features/support/repositories/support_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/utils/extensions.dart';

class SupportEditController extends GetxController {
  final User user = Get.find();

  final SupportRepository _repository = Get.put(SupportRepository());

  final subject = ''.obs;
  final description = ''.obs;
  final phone = ''.obs;
  final isWhatsApp = RxBool(true);

  String get supportError {
    if (isPhoneValid.isFalse) {
      return 'Insira um telefone válido';
    } else if (isSubjectValid.isFalse) {
      return 'Insira um assunto válido';
    } else if (isDescriptionValid.isFalse) {
      return 'Por favor, descreva o seu problema';
    } else {
      return 'Algum campo necessita de atenção';
    }
  }

  final showErrors = false.obs;
  final loading = false.obs;

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  @override
  void onInit() {
    super.onInit();

    phone.value = user.phone;
  }

  RxBool get isValid => (isSubjectValid.isTrue &&
          isDescriptionValid.isTrue &&
          isPhoneValid.isTrue)
      .obs;

  RxBool get isSubjectValid => subject.value.isNotEmpty.obs;

  RxBool get isDescriptionValid => description.value.isNotEmpty.obs;

  RxBool get isPhoneValid {
    final cleanPhone = phone.value.clean.removeParenthesis.removeAllWhitespace;

    print('${cleanPhone.length == 11}');
    return (cleanPhone.length == 11).obs;
  }

  Future<SaveResult> save() async {
    loading(true);

    final support = Support(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: description.value,
      subject: subject.value,
      phone: phone.value,
      isWhatsApp: isWhatsApp.value,
    );

    final result = await _repository.save(support);

    loading(false);
    return result;
  }
}
