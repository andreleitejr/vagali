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

  RxString get postalCodeClean =>
      postalCode.replaceAll('.', '').replaceAll('-', '').obs;

  Future<void> fetchAddressDetails() async {
    if (validatePostalCode.isTrue) {
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

  @override
  void onInit() {
    super.onInit();
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

  bool isValid() {
    return isPersonalInfoValid.isTrue && isAddressValid.isTrue;
  }

  RxBool get isPersonalInfoValid => (validateImage.isTrue &&
          validateFirstName.isTrue &&
          validateLastName.isTrue &&
          validateDocument.isTrue &&
          validateEmail.isTrue &&
          validateBirthday.isTrue)
      .obs;

  RxBool get isAddressValid => (validatePostalCode.isTrue &&
          validateNumber.isTrue &&
          validateStreet.isTrue &&
          validateCity.isTrue &&
          validateState.isTrue)
      .obs;

  RxBool get validateImage {
    // imageError.value = isValid ? '' : 'Selecione uma imagem';
    return (imageFile.value != null && imageFile.value!.path.isNotEmpty).obs;
  }

  RxBool get validateFirstName {
    // firstNameError.value = isValid ? '' : 'Nome não pode estar vazio';
    return firstName.isNotEmpty.obs;
  }

  RxBool get validateLastName {
    // lastNameError.value = isValid ? '' : 'Sobrenome não pode estar vazio';
    return lastName.isNotEmpty.obs;
  }

  RxBool get validateDocument {
    final cpf = document.replaceAll(RegExp(r'[^\d]'), '');
    // if (cpf.isEmpty || cpf.length != 11 || !GetUtils.isCpf(cpf)) {
    //   // documentError.value = 'CPF inválido';
    //   return false.obs;
    // }
    //
    // documentError.value = '';
    // return true.obs;

    return (cpf.isNotEmpty && cpf.length == 11 && GetUtils.isCpf(cpf)).obs;
  }

  RxBool get validateEmail {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (email.isEmpty) {
      emailError.value = 'Email não pode estar vazio';
      return false.obs;
    } else if (!emailRegExp.hasMatch(email.value)) {
      emailError.value = 'Email inválido';
      return false.obs;
    } else {
      emailError.value = '';
      return true.obs;
    }
  }

  RxBool get validateBirthday {
    // birthdayError.value = isValid ? '' : 'Data de aniversário inválida';
    return (birthdayDate.value != null).obs;
  }

  RxBool get validatePostalCode {
    // postalCodeError.value = isValid ? '' : 'Insira um CEP';
    return (postalCodeClean.isNotEmpty && postalCodeClean.value.length >= 8)
        .obs;
  }

  RxBool get validateStreet {
    // streetError.value = isValid ? '' : 'Insira o nome da rua';
    return street.isNotEmpty.obs;
  }

  RxBool get validateNumber {
    // streetError.value = isValid ? '' : 'Insira o nome da rua';
    return number.isNotEmpty.obs;
  }

  RxBool get validateCity {
    // cityError.value = isValid ? '' : 'Insira uma cidade';
    return city.isNotEmpty.obs;
  }

  RxBool get validateState {
    // stateError.value = isValid ? '' : 'Escolha um estado';
    return state.isNotEmpty.obs;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
