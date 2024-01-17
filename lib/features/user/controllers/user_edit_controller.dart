import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/gender.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/address_service.dart';
import 'package:vagali/services/image_service.dart';

class UserEditController extends GetxController {
  UserEditController({this.type});

  final String? type;
  final UserRepository _repository = UserRepository();
  final AuthRepository _authRepository = Get.find();

  final currentUser = Rx<User?>(null);

  RxBool get hasCurrentUser => (currentUser.value != null).obs;

  void fillFormWithUserData() {
    final user = currentUser.value!;

    print('######################### USER EXISTES NAME: ${user.firstName}');
    print('######################### USER EXISTES NAME: ${user.lastName}');
    print('######################### USER EXISTES NAME: ${user.email}');
    print('######################### USER EXISTES NAME: ${user.document}');

    firstNameController.value = user.firstName;
    lastNameController.value = user.lastName;
    emailController.value = user.email;
    documentController.value = user.document;
    genderController.text =
        genders.firstWhereOrNull((g) => g.value == user.gender)?.title ?? '';
    birthday.value = user.birthday;
    imageBlurhash.value = user.image;

    postalCodeController.value = user.address.postalCode;
    streetController.value = user.address.street;
    numberController.value = user.address.number;
    cityController.value = user.address.city;
    stateController.value = user.address.state;
    countryController.value = user.address.country;
    complementController.value = user.address.complement ?? '';
  }

  final _imageService = Get.put(ImageService());
  final AddressService _addressService = AddressService();

  final firstNameController = ''.obs;
  final lastNameController = ''.obs;
  final emailController = ''.obs;
  final documentController = ''.obs;

  final genderController = TextEditingController();

  final Rx<DateTime?> birthday = Rx<DateTime?>(null);

  var imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFile = Rx<XFile?>(null);

  // final imageUrlController = TextEditingController();
  final postalCodeController = ''.obs;
  final streetController = ''.obs;
  final numberController = ''.obs;
  final cityController = ''.obs;
  final stateController = ''.obs;
  final countryController = ''.obs;
  final complementController = ''.obs;

  RxString get postalCodeClean =>
      postalCodeController.value.replaceAll('.', '').replaceAll('-', '').obs;

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

  RxBool get isPostalCodeValid =>
      (postalCodeClean.isNotEmpty && postalCodeClean.value.length >= 8).obs;

  final isPostalCodeLoading = false.obs;

  Future<void> fetchAddressDetails() async {
    if (isPostalCodeValid.isTrue) {
      isPostalCodeLoading.value = true;
      final addressDetails =
          await _addressService.getAddressDetails(postalCodeClean.value);

      if (addressDetails != null) {
        streetController.value = addressDetails['logradouro'] ?? '';
        cityController.value = addressDetails['localidade'] ?? '';
        stateController.value = addressDetails['uf'] ?? '';
        countryController.value = 'Brasil';
      }

      isPostalCodeLoading.value = false;
    }
  }

  RxBool get isStreetValid => streetController.value.isNotEmpty.obs;

  RxBool get isNumberValid => numberController.value.isNotEmpty.obs;

  RxBool get isCityValid => cityController.value.isNotEmpty.obs;

  RxBool get isStateValid => stateController.value.isNotEmpty.obs;

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
      firstName: firstNameController.value,
      lastName: lastNameController.value,
      document: documentController.value,
      email: emailController.value,
      phone: Get.find<String>(tag: 'phoneNumber'),
      gender: genders.firstWhere((g) => g.name == genderController.text).value,
      birthday: birthday.value!,
      address: Address(
        postalCode: postalCodeController.value,
        street: streetController.value,
        number: numberController.value,
        city: cityController.value,
        state: stateController.value,
        country: countryController.value,
        complement: complementController.value,
      ),
      type: type ?? currentUser.value!.type,
    );

    final result = await _repository.save(user, docId: user.id);

    if (result == SaveResult.success) {
      Get.put<User>(user);
      debugPrint('Successful saved user with id ${user.id}...');
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
  Future<void> onInit() async {
    loading.value = true;
    await verifyUser();
    ever(postalCodeController, (_) {
      fetchAddressDetails();
      update();
    });
    loading.value = false;
    super.onInit();
  }

  Future<void> verifyUser() async {

    bool userExists = Get.isRegistered<User>();

    if (userExists) {
      print('O USUARIO EXISTE HEHEHEHEHEHEHE');

      final User localUser = Get.find();

      final user = await _repository.get(localUser.id!);

      if (user != null) {
        currentUser.value = user;
        fillFormWithUserData();
        print(
            '################################## USER EXISTES NAME: ${currentUser.value!.firstName}');
      }
    }
  }

  @override
  void onClose() {
    genderController.clear();
    super.onClose();
  }
}
