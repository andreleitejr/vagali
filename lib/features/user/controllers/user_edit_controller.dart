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
  UserEditController(this.type);

  final String type;
  final UserRepository _repository = UserRepository();
  final AuthRepository _authRepository = Get.find();

  final _imageService = Get.put(ImageService());
  final AddressService _addressService = AddressService();

  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final document = ''.obs;
  final gender = ''.obs;

  final birthday = ''.obs;
  final birthdayDate = Rx<DateTime?>(null);

  var imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFile = Rx<XFile?>(null);
  final postalCode = ''.obs;
  final street = ''.obs;
  final number = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final country = ''.obs;
  final complement = ''.obs;

  RxString get postalCodeClean =>
      postalCode.replaceAll('.', '').replaceAll('-', '').obs;

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
    if (email.isEmpty) {
      return 'Email não pode estar vazio'.obs;
    } else if (!emailRegExp.hasMatch(email.value)) {
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

  bool isValid() => isPersonalInfoValid.isTrue && isAddressValid.isTrue;

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
    return (imageFile.value != null && imageFile.value!.path.isNotEmpty).obs;
  }

  RxBool get isFirstNameValid => firstName.isNotEmpty.obs;

  RxBool get isLastNameValid => lastName.isNotEmpty.obs;

  RxBool get isDocumentValid {
    final cpf = document.replaceAll(RegExp(r'[^\d]'), '');

    return (cpf.isNotEmpty && cpf.length == 11 && GetUtils.isCpf(cpf)).obs;
  }

  RxBool get isEmailValid {
    return (email.isNotEmpty && emailRegExp.hasMatch(email.value)).obs;
  }

  RxBool get isBirthdayValid => (birthdayDate.value != null).obs;

  RxBool get isPostalCodeValid =>
      (postalCodeClean.isNotEmpty && postalCodeClean.value.length >= 8).obs;

  Future<void> fetchAddressDetails() async {
    if (isPostalCodeValid.isTrue) {
      final addressDetails =
          await _addressService.getAddressDetails(postalCodeClean.value);
      if (addressDetails != null) {
        street.value = addressDetails['logradouro'] ?? '';
        city.value = addressDetails['localidade'] ?? '';
        state.value = addressDetails['uf'] ?? '';
        country.value = 'Brasil';
      }
    }
  }

  RxBool get isStreetValid => street.isNotEmpty.obs;

  RxBool get isNumberValid => number.isNotEmpty.obs;

  RxBool get isCityValid {
    // cityError.value = isValid ? '' : 'Insira uma cidade';
    return city.isNotEmpty.obs;
  }

  RxBool get isStateValid {
    // stateError.value = isValid ? '' : 'Escolha um estado';
    return state.isNotEmpty.obs;
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

  Future<ImageBlurHash?> uploadImage() async {
    final image = await _imageService.buildImageBlurHash(
      imageFile.value!,
      'users',
    );

    if (image == null) {
      imageError.value = 'Falha ao carregar a imagem';
    }

    return image;
  }

  Future<SaveResult?> save() async {
    loading(true);

    imageBlurhash.value = await uploadImage();

    if (imageBlurhash.value == null) return SaveResult.failed;

    final user = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      image: imageBlurhash.value!,
      firstName: firstName.value,
      lastName: lastName.value,
      document: document.value,
      email: email.value,
      phone: Get.find<String>(tag: 'phoneNumber'),
      birthday: birthdayDate.value!,
      address: Address(
        postalCode: postalCode.value,
        street: street.value,
        number: number.value,
        city: city.value,
        state: state.value,
        country: country.value,
        complement: complement.value,
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
  void onClose() {
    super.onClose();
  }
}
