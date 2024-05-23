import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/address/controllers/address_edit_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/user/models/gender.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/image_service.dart';

class LandlordEditController extends GetxController {
  LandlordEditController();

  final _landlordRepository = LandlordRepository();

  final AuthRepository _authRepository = Get.find();

  final addressController = Get.put(AddressEditController());

  final currentUser = Rx<User?>(null);

  RxBool get hasCurrentUser => (currentUser.value != null).obs;

  void fillFormWithUserData() {
    final user = currentUser.value!;

    firstNameController.value = user.firstName;
    lastNameController.value = user.lastName;
    emailController.value = user.email;
    documentController.value = user.document;
    genderController.text =
        genders.firstWhereOrNull((g) => g.value == user.gender)?.title ?? '';
    birthday.value = user.birthday;
    imageBlurhash.value = user.image;
  }

  final _imageService = Get.put(ImageService());

  final firstNameController = ''.obs;
  final lastNameController = ''.obs;
  final emailController = ''.obs;
  final documentController = ''.obs;

  final genderController = TextEditingController();

  final Rx<DateTime?> birthday = Rx<DateTime?>(null);

  var imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFile = Rx<XFile?>(null);

  // final imageUrlController = TextEditingController();

  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  RxString get imageError => (isImageValid.isTrue ? '' : 'Insira uma foto').obs;

  RxString get firstNameError =>
      (isFirstNameValid.isTrue ? '' : 'O primeiro nome não pode estar vazio')
          .obs;

  RxString get lastNameError =>
      (isLastNameValid.isTrue ? '' : 'Sobrenome não pode estar vazio').obs;

  RxString get documentError =>
      (isDocumentValid.isTrue ? '' : 'CPF inválido').obs;

  RxString get emailError {
    if (emailController.value.isEmpty) {
      return 'Email não pode estar vazio'.obs;
    } else if (!emailRegExp.hasMatch(emailController.value)) {
      return 'Email inválido'.obs;
    } else {
      return ''.obs;
    }
  }

  RxString get birthdayError =>
      (isBirthdayValid.isTrue ? '' : 'Data de aniversário inválida').obs;

  final loading = RxBool(false);

  final showErrors = RxBool(false);

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  RxBool get isValid =>
      (isPersonalInfoValid.isTrue && addressController.isAddressValid.isTrue)
          .obs;

  RxBool get isPersonalInfoValid => (isImageValid.isTrue &&
          isFirstNameValid.isTrue &&
          isLastNameValid.isTrue &&
          isDocumentValid.isTrue &&
          isEmailValid.isTrue &&
          isBirthdayValid.isTrue)
      .obs;

  RxBool get isImageValid {
    if (currentUser.value == null) {
      return (imageFile.value != null && imageFile.value!.path.isNotEmpty).obs;
    } else {
      return true.obs;
    }
  }

  RxBool get isFirstNameValid => firstNameController.value.isNotEmpty.obs;

  RxBool get isLastNameValid => lastNameController.value.isNotEmpty.obs;

  RxBool get isDocumentValid {
    final cpf = documentController.value.replaceAll(RegExp(r'[^\d]'), '');

    return (cpf.isNotEmpty && cpf.length == 11 && GetUtils.isCpf(cpf)).obs;
  }

  RxBool get isEmailValid => (emailController.value.isNotEmpty &&
          emailRegExp.hasMatch(emailController.value))
      .obs;

  RxBool get isBirthdayValid => (birthday.value != null).obs;

  RxBool validateCurrentStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return isPersonalInfoValid;
      case 1:
        return addressController.isAddressValid;
      default:
        return true.obs;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final image = await _imageService.pickImage(source);

    if (image != null) {
      imageFile.value = image;
      buildImageBlurhash();
    } else {
      imageError.value = 'Falha ao carregar a imagem';
    }
  }

  Future<void> buildImageBlurhash() async {
    final blurhash = await _getBlurhash();
    final imageUrl = await _getImageUrl();
    if (blurhash != null && imageUrl != null) {
      imageBlurhash.value = ImageBlurHash(image: imageUrl, blurHash: blurhash);
    }
  }

  Future<String?> _getBlurhash() async {
    if (imageFile.value != null) {
      final blurhash = await _imageService.getBlurhash(imageFile.value!);

      if (blurhash == null) {
        imageError.value = 'Falha ao carregar a imagem';
      }

      return blurhash;
    }
    return null;
  }

  Future<String?> _getImageUrl() async {
    if (imageFile.value != null) {
      final imageUrl =
          await _imageService.uploadImage(imageFile.value!, 'landlords');

      if (imageUrl == null) {
        imageError.value = 'Falha ao carregar a imagem';
      }

      return imageUrl;
    }
    return null;
  }

  Future<SaveResult?> save() async {
    loading(true);

    if (imageBlurhash.value == null) return SaveResult.failed;

    final user = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      image: imageBlurhash.value!,
      firstName: firstNameController.value,
      lastName: lastNameController.value,
      document: documentController.value,
      email: emailController.value,
      phone: Get.find<String>(tag: 'phoneNumber'),
      gender: genders.firstWhere((g) => g.name == genderController.text).value,
      birthday: birthday.value!,
      address: addressController.address,
      // type: UserType.landlord,
    );

    final result =
        await _landlordRepository.save(Landlord.fromUser(user), docId: user.id);

    if (result == SaveResult.success) {
      Get.put<User>(user);
      return SaveResult.success;
    }
    loading(false);
    return SaveResult.failed;
  }

  @override
  Future<void> onInit() async {
    loading.value = true;
    await verifyUser();
    loading.value = false;
    super.onInit();
  }

  Future<void> verifyUser() async {
    bool userExists = Get.isRegistered<User>();

    if (userExists) {
      final User localUser = Get.find();

      final user = await _landlordRepository.get(localUser.id!);

      if (user != null) {
        currentUser.value = user;
        fillFormWithUserData();
      }
    }
  }

  @override
  void onClose() {
    genderController.clear();
    super.onClose();
  }
}
