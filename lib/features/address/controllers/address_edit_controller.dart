import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/services/address_service.dart';

class AddressEditController extends GetxController {
  @override
  Future<void> onInit() async {
    ever(postalCodeController, (_) {
      fetchAddressDetails();
      update();
    });
    super.onInit();
  }

  final AddressService _addressService = AddressService();

  final currentAddress = Rx<Address?>(null);

  final isPostalCodeLoading = false.obs;

  final showErrors = RxBool(false);

  final postalCodeController = ''.obs;
  final streetController = ''.obs;
  final numberController = ''.obs;
  final countyController = ''.obs;
  final cityController = ''.obs;
  final stateController = ''.obs;
  final countryController = ''.obs;
  final complementController = ''.obs;

  void fillFormWithUserData(Address address) {
    postalCodeController.value = address.postalCode;
    streetController.value = address.street;
    numberController.value = address.number;
    cityController.value = address.city;
    stateController.value = address.state;
    countryController.value = address.country;
    complementController.value = address.complement ?? '';
  }

  Future<GeoPoint?> getCoordinatesFromAddress() async {
    return await _addressService.getCoordinatesFromAddress(
      address,
    );
  }

  Future<Map<String, dynamic>?> getAddressDetails() async {
    return await _addressService.getAddressDetails(postalCodeController.value);
  }

  Future<void> fetchAddressDetails() async {
    if (isPostalCodeValid.isTrue) {
      isPostalCodeLoading.value = true;
      final addressDetails =
          await _addressService.getAddressDetails(postalCodeClean.value);

      if (addressDetails != null) {
        streetController.value = addressDetails['logradouro'] ?? '';
        countyController.value = addressDetails['bairro'] ?? '';
        cityController.value = addressDetails['localidade'] ?? '';
        stateController.value = addressDetails['uf'] ?? '';
        countryController.value = 'Brasil';
      }

      isPostalCodeLoading.value = false;
    }
  }

  RxString get postalCodeClean =>
      postalCodeController.value.replaceAll('.', '').replaceAll('-', '').obs;

  RxString get postalCodeError =>
      (isPostalCodeValid.isTrue ? '' : 'Insira um CEP').obs;

  RxString get streetError =>
      (isStreetValid.isTrue ? '' : 'Insira o nome da rua').obs;

  RxString get numberError =>
      (isNumberValid.isTrue ? '' : 'Insira o número').obs;

  RxString get cityError => (isCityValid.isTrue ? '' : 'Insira uma cidade').obs;

  RxString get stateError =>
      (isStateValid.isTrue ? '' : 'Insira um estado').obs;

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  RxBool get isPostalCodeValid =>
      (postalCodeClean.isNotEmpty && postalCodeClean.value.length >= 8).obs;

  RxBool get isStreetValid => streetController.value.isNotEmpty.obs;

  RxBool get isNumberValid => numberController.value.isNotEmpty.obs;

  RxBool get isCityValid => cityController.value.isNotEmpty.obs;

  RxBool get isStateValid => stateController.value.isNotEmpty.obs;

  RxBool get isAddressValid => (isPostalCodeValid.isTrue &&
          isNumberValid.isTrue &&
          isStreetValid.isTrue &&
          isCityValid.isTrue &&
          isStateValid.isTrue)
      .obs;

  Address get address => Address(
        postalCode: postalCodeController.value,
        street: streetController.value,
        number: numberController.value,
        county: countyController.value,
        city: cityController.value,
        state: stateController.value,
        country: countryController.value,
        complement: complementController.value,
      );
}
