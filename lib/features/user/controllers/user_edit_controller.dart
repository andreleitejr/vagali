import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/address_service.dart';
import 'package:vagali/services/image_service.dart';

class UserEditController extends GetxController {
  UserEditController(this.type, {this.user}) {
    if (user != null) setUserToEdit(user!);
  }

  final User? user;

  Rx<User?> currentUser = Rx<User?>(null);

  RxBool get hasCurrentUser => (currentUser.value != null).obs;

  void setUserToEdit(User user) {
    currentUser.value = user;
    fillFormWithUserData();
  }

  void fillFormWithUserData() {
    final user = currentUser.value!;

    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
    documentController.text = user.document;
    genderController.text = user.gender;
    birthday.value = user.birthday;
    imageBlurhash.value = user.image;

    postalCodeController.text = user.address.postalCode;
    streetController.text = user.address.street;
    numberController.text = user.address.number;
    cityController.text = user.address.city;
    stateController.text = user.address.state;
    countryController.text = user.address.country;
    complementController.text = user.address.complement ?? '';
  }

  final String type;
  final UserRepository _repository = UserRepository();
  final AuthRepository _authRepository = Get.find();

  final _imageService = Get.put(ImageService());
  final AddressService _addressService = AddressService();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final documentController = TextEditingController();
  final genderController = TextEditingController();

  final Rx<DateTime?> birthday = Rx<DateTime?>(null);

  var imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFile = Rx<XFile?>(null);

  // final imageUrlController = TextEditingController();
  final postalCodeController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final complementController = TextEditingController();

  RxString get postalCodeClean =>
      postalCodeController.text.replaceAll('.', '').replaceAll('-', '').obs;

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
    if (emailController.text.isEmpty) {
      return 'Email não pode estar vazio'.obs;
    } else if (!emailRegExp.hasMatch(emailController.text)) {
      return 'Email inválido'.obs;
    } else {
      return ''.obs;
    }
  }

  RxString get birthdayError =>
      (isBirthdayValid.isTrue ? '' : 'Data de aniversário inválida').obs;

  RxString get postalCodeError =>
      (isPostalCodeValid.isTrue ? '' : 'Insira um CEP').obs;

  RxString get streetError =>
      (isStreetValid.isTrue ? '' : 'Insira o nome da rua').obs;

  RxString get numberError =>
      (isNumberValid.isTrue ? '' : 'Insira o número').obs;

  RxString get cityError => (isCityValid.isTrue ? '' : 'Insira uma cidade').obs;

  RxString get stateError =>
      (isStateValid.isTrue ? '' : 'Insira um estado').obs;

  var loading = RxBool(false);

  final showErrors = RxBool(false);

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  RxBool get isValid =>
      (isPersonalInfoValid.isTrue && isAddressValid.isTrue).obs;

  RxBool get isPersonalInfoValid => (isImageValid.isTrue &&
          isFirstNameValid.isTrue &&
          isLastNameValid.isTrue &&
          isDocumentValid.isTrue &&
          isEmailValid.isTrue &&
          isBirthdayValid.isTrue)
      .obs;

  RxBool get isAddressValid => (isPostalCodeValid.isTrue &&
          isNumberValid.isTrue &&
          isStreetValid.isTrue &&
          isCityValid.isTrue &&
          isStateValid.isTrue)
      .obs;

  RxBool get isImageValid {
    if (currentUser.value == null) {
      return (imageFile.value != null && imageFile.value!.path.isNotEmpty).obs;
    } else {
      return true.obs;
    }
  }

  RxBool get isFirstNameValid => firstNameController.text.isNotEmpty.obs;

  RxBool get isLastNameValid => lastNameController.text.isNotEmpty.obs;

  RxBool get isDocumentValid {
    final cpf = documentController.text.replaceAll(RegExp(r'[^\d]'), '');

    return (cpf.isNotEmpty && cpf.length == 11 && GetUtils.isCpf(cpf)).obs;
  }

  RxBool get isEmailValid {
    return (emailController.text.isNotEmpty &&
            emailRegExp.hasMatch(emailController.text))
        .obs;
  }

  RxBool get isBirthdayValid => (birthday.value != null).obs;

  RxBool get isPostalCodeValid =>
      (postalCodeClean.isNotEmpty && postalCodeClean.value.length >= 8).obs;

  Future<void> fetchAddressDetails() async {
    if (isPostalCodeValid.isTrue) {
      final addressDetails =
          await _addressService.getAddressDetails(postalCodeClean.value);
      if (addressDetails != null) {
        streetController.text = addressDetails['logradouro'] ?? '';
        cityController.text = addressDetails['localidade'] ?? '';
        stateController.text = addressDetails['uf'] ?? '';
        countryController.text = 'Brasil';
      }
    }
  }

  RxBool get isStreetValid => streetController.text.isNotEmpty.obs;

  RxBool get isNumberValid => numberController.text.isNotEmpty.obs;

  RxBool get isCityValid {
    return cityController.text.isNotEmpty.obs;
  }

  RxBool get isStateValid {
    return stateController.text.isNotEmpty.obs;
  }

  RxBool validateCurrentStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return isPersonalInfoValid;
      case 1:
        return isAddressValid;
      default:
        return true.obs;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final imageUrl = await _imageService.pickImage(source);

    if (imageUrl != null) {
      imageFile.value = imageUrl;
    } else {
      imageError.value = 'Falha ao carregar a imagem';
    }
  }

  Future<void> uploadImage() async {
    if (imageFile.value != null) {
      final image = await _imageService.buildImageBlurHash(
        imageFile.value!,
        'users',
      );

      if (image == null) {
        imageError.value = 'Falha ao carregar a imagem';
        return;
      }

      imageBlurhash.value = image;
    }
  }

  Future<SaveResult?> save() async {
    loading(true);

    if (imageBlurhash.value == null) return SaveResult.failed;

    final user = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      image: imageBlurhash.value!,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      document: documentController.text,
      email: emailController.text,
      phone: Get.find<String>(tag: 'phoneNumber'),
      gender: genderController.text,
      birthday: birthday.value!,
      address: Address(
        postalCode: postalCodeController.text,
        street: streetController.text,
        number: numberController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        complement: complementController.text,
      ),
      type: type,
    );

    final result = await _repository.save(user, docId: user.id);

    if (result == SaveResult.success) {
      Get.put<User>(user);
      if (user.type == UserType.tenant) {
        final tenant = Tenant.fromUser(user);
        Get.put<Tenant>(tenant);
      } else if (user.type == UserType.landlord) {
        final landlord = Landlord.fromUser(user);
        Get.put<Landlord>(landlord);
      }
      loading(false);
      return SaveResult.success;
    }
    loading(false);
    return SaveResult.failed;
  }

  @override
  void onInit() {
    postalCodeController.addListener(() => fetchAddressDetails());
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    clearControllers();
  }

  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    documentController.clear();
    genderController.clear();
    birthday.value = null;
    postalCodeController.clear();
    streetController.clear();
    numberController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    complementController.clear();
  }
}
