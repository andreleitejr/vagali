import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/support/models/support.dart';
import 'package:vagali/features/support/repositories/support_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class SupportEditController extends GetxController {
  final User user = Get.find();

  final SupportRepository _repository = Get.put(SupportRepository());

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final isWhatsAppController = RxBool(true);

  final subjectError = RxString('');
  final descriptionError = RxString('');
  final phoneError = RxString('');

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

    phoneController.text = user.phone;

    subjectController.addListener(() => validateSubject());
    descriptionController.addListener(() => validateDescription());
    phoneController.addListener(() => validatePhone());
  }

  bool validateSubject() {
    final isValid = subjectController.text.isNotEmpty;
    subjectError.value = isValid ? '' : 'Insira o motivo de pedido de suporte';
    return isValid;
  }

  bool validateDescription() {
    final isValid = descriptionController.text.isNotEmpty;
    descriptionError.value = isValid ? '' : 'Descrição não pode estar vazia';
    return isValid;
  }

  bool validatePhone() {
    final isValid = phoneController.text.isNotEmpty;
    phoneError.value = isValid ? '' : 'É necessário um telefone para contato';
    return isValid;
  }

  Future<SaveResult> save() async {
    loading(true);

    final subject = subjectController.text;
    final description = descriptionController.text;
    final phone = phoneController.text;
    final isWhatsApp = isWhatsAppController.value;

    final support = Support(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: description,
      subject: subject,
      phone: phone,
      isWhatsApp: isWhatsApp,
    );

    final result = await _repository.save(support);

    loading(false);
    return result;
  }
}
