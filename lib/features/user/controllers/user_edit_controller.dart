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
import 'package:vagali/utils/extensions.dart';

class UserEditController extends GetxController {
  UserEditController(this.type);

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

  final birthdayController = TextEditingController();
  final birthdayDate = Rx<DateTime?>(null);

  var imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFileController = Rx<XFile?>(null);
  final postalCodeController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final complementController = TextEditingController();

  final firstNameError = RxString('');
  final lastNameError = RxString('');
  final emailError = RxString('');
  final documentError = RxString('');

  // final phoneError = RxString('');
  final birthdayError = RxString('');
  final postalCodeError = RxString('');
  final cityError = RxString('');
  final stateError = RxString('');
  final streetError = RxString('');
  final imageError = RxString('');

  var loading = RxBool(false);

  final showErrors = RxBool(false);

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  Future<void> pickImage(ImageSource source) async {
    final imageUrl = await _imageService.pickImage(source);

    if (imageUrl != null) {
      imageFileController.value = imageUrl;
    } else {
      imageError.value = 'Falha ao carregar a imagem';
    }
  }

  Future<ImageBlurHash?> uploadImage() async {
    final image = await _imageService.buildImageBlurHash(
      imageFileController.value!,
      'users',
    );

    if (image == null) {
      imageError.value = 'Falha ao carregar a imagem';
    }

    return image;
  }

  void fetchAddressDetails() async {
    final postalCode = postalCodeController.text;
    if (postalCode.isNotEmpty) {
      final addressDetails = await _addressService.getAddressDetails(
        postalCode.replaceAll('.', '').replaceAll('-', ''),
      );
      if (addressDetails != null) {
        streetController.text = addressDetails['logradouro'] ?? '';
        cityController.text = addressDetails['localidade'] ?? '';
        stateController.text = addressDetails['uf'] ?? '';
        countryController.text = 'Brasil';
      }
    }
  }

  @override
  void onInit() {
    super.onInit();

    firstNameController.addListener(() {
      validateFirstName();
    });

    lastNameController.addListener(() {
      validateLastName();
    });

    documentController.addListener(() {
      validateDocument();
    });

    emailController.addListener(() {
      validateEmail();
    });

    genderController.addListener(() {
      // validateGender();
    });

    postalCodeController.addListener(() {
      validatePostalCode();
      fetchAddressDetails();
    });

    cityController.addListener(() {
      validateCity();
    });
    stateController.addListener(() {
      validateState();
    });
  }

  bool validateCurrentStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return validateImage() &&
            validateFirstName() &&
            validateLastName() &&
            validateDocument() &&
            validateEmail() &&
            validateBirthday();
      case 1:
        return validatePostalCode() &&
            validateStreet() &&
            validateCity() &&
            validateState();
      default:
        return true;
    }
  }

  Future<SaveResult?> save() async {
    loading(true);

    imageBlurhash.value = await uploadImage();

    if (imageBlurhash.value == null) return SaveResult.failed;

    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final document = documentController.text;
    final email = emailController.text;
    // final birthday = DateTime.tryParse(birthdayController.text);
    final postalCode = postalCodeController.text;
    final street = streetController.text;
    final number = numberController.text;
    final city = cityController.text;
    final state = stateController.text;
    final country = countryController.text;
    final complement = complementController.text;

    final user = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      image: imageBlurhash.value!,
      firstName: firstName,
      lastName: lastName,
      document: document,
      email: email,
      phone: Get.find<String>(tag: 'phoneNumber'),
      birthday: birthdayDate.value!,
      address: Address(
        postalCode: postalCode,
        street: street,
        number: number,
        city: city,
        state: state,
        country: country,
        complement: complement,
      ),
      type: type,
    );

    final result = await _repository.save(user, docId: user.id);

    if (result == SaveResult.success) {
      Get.put<User>(user);
      if (user.type == UserType.tenant) {
        final tenant = Tenant.fromUser(user);
        Get.put<Tenant>(tenant);
        print('###################################');
        print(
            '######### TENANT WAS SET - ${Get.find<Tenant>().id} ###########');
        print('###################################');
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

  bool isValid() {
    final isImageValid = validateImage();
    final isFirstNameValid = validateFirstName();
    final isLastNameValid = validateLastName();
    final isDocumentValid = validateDocument();
    final isEmailValid = validateEmail();
    final isBirthdayValid = validateBirthday();
    final isPostalCodeValid = validatePostalCode();
    final isCityValid = validateCity();
    final isStateValid = validateState();

    return isImageValid &&
        isFirstNameValid &&
        isLastNameValid &&
        isDocumentValid &&
        isEmailValid &&
        // isPhoneValid &&
        isBirthdayValid &&
        isPostalCodeValid &&
        isCityValid &&
        isStateValid;
  }

  bool validateImage() {
    final isValid = imageFileController.value != null &&
        imageFileController.value!.path.isNotEmpty;
    imageError.value = isValid ? '' : 'Selecione uma imagem';
    return isValid;
  }

  bool validateFirstName() {
    final isValid = firstNameController.text.isNotEmpty;
    firstNameError.value = isValid ? '' : 'Nome não pode estar vazio';
    return isValid;
  }

  bool validateLastName() {
    final isValid = lastNameController.text.isNotEmpty;
    lastNameError.value = isValid ? '' : 'Sobrenome não pode estar vazio';
    return isValid;
  }

  bool validateDocument() {
    final cpf = documentController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cpf.isEmpty || cpf.length != 11 || !GetUtils.isCpf(cpf)) {
      documentError.value = 'CPF inválido';
      return false;
    }

    documentError.value = '';
    return true;
  }

  bool validateEmail() {
    final email = emailController.text;
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (email.isEmpty) {
      emailError.value = 'Email não pode estar vazio';
      return false;
    } else if (!emailRegExp.hasMatch(email)) {
      emailError.value = 'Email inválido';
      return false;
    } else {
      emailError.value = '';
      return true;
    }
  }

  bool validateBirthday() {
    final isValid = birthdayDate.value != null;
    birthdayError.value = isValid ? '' : 'Data de aniversário inválida';
    return isValid;
  }

  bool validatePostalCode() {
    final isValid = postalCodeController.text.isNotEmpty;
    postalCodeError.value = isValid ? '' : 'Insira um CEP';
    return isValid;
  }

  bool validateStreet() {
    final isValid = streetController.text.isNotEmpty;
    streetError.value = isValid ? '' : 'Insira o nome da rua';
    return isValid;
  }

  bool validateCity() {
    final isValid = cityController.text.isNotEmpty;
    cityError.value = isValid ? '' : 'Insira uma cidade';
    return isValid;
  }

  bool validateState() {
    final isValid = stateController.text.isNotEmpty;
    stateError.value = isValid ? '' : 'Escolha um estado';
    return isValid;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    emailController.dispose();
    // phoneController.dispose();
    streetController.dispose();
    numberController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    complementController.dispose();
    super.onClose();
  }
}
