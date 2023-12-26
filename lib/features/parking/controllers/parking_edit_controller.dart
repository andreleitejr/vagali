import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/auth/controllers/auth_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/parking/models/gate.dart';
import 'package:vagali/features/parking/models/opening_hours.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/models/parking_type.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/services/address_service.dart';
import 'package:vagali/services/garage_service.dart';
import 'package:vagali/services/image_service.dart';
import 'package:vagali/services/price_service.dart';
import 'package:vagali/services/schedule_service.dart';

class ParkingEditController extends GetxController {
  final Landlord landlord = Get.find();
  final ParkingRepository _repository = ParkingRepository();
  final AuthRepository _authRepository = Get.find();

  final ImageService _imageService = ImageService();
  final AddressService _addressService = AddressService();

  final GarageService _garageService = GarageService();

  final ScheduleService scheduleService = ScheduleService();
  final RxInt currentStep = 0.obs;
  final selectedGalleryImages = <XFile>[].obs;
  final selectedImagesBlurhash = <ImageBlurHash>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController coordinatesController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController complementController = TextEditingController();

  // final List<File> imageFiles = <File>[];
  final Rx<ParkingType?> parkingType = Rx<ParkingType?>(null);
  final parkingTags = <ParkingTag>[].obs;
  final gateHeight = 3.0.obs;
  final gateWidth = 4.0.obs;
  final garageDepth = 6.0.obs;
  final isAutomaticController = RxBool(false);
  final compatibleCarTypes = <VehicleTypeEnum>[].obs;

  final priceController = 8.0.obs;

  final nameError = RxString('');
  final tagsError = RxString('');
  final priceError = RxString('');
  final descriptionError = RxString('');

  // final operatingHoursError = RxString('');
  final coordinatesError = RxString('');
  final postalCodeError = RxString('');
  final streetError = RxString('');
  final numberError = RxString('');
  final cityError = RxString('');
  final stateError = RxString('');
  final countryError = RxString('');
  final complementError = RxString('');
  final imageError = RxString('');
  final addressError = RxString('');
  final gateHeightError = RxString('');
  final gateWidthError = RxString('');
  final garageDepthError = RxString('');

  final showErrors = false.obs;
  final loading = false.obs;

  int get totalSteps => 5;

  @override
  void onInit() {
    super.onInit();
    fillAddressFromLandlord();

    /// Modificar em versoes posteriores
    selectType(parkingTypes[1]); // Casas
    updateCompatibleCarTypes();
    nameController.addListener(() => validateName());
    descriptionController.addListener(() => validateDescription());
    coordinatesController.addListener(() => validateCoordinates());
    postalCodeController.addListener(() {
      validatePostalCode();
      fetchAddressDetails();
    });
    streetController.addListener(() => validateStreet());
    numberController.addListener(() => validateNumber());
    cityController.addListener(() => validateCity());
    stateController.addListener(() => validateState());
    countryController.addListener(() => validateCountry());
    complementController.addListener(() => validateComplement());

    ever(gateHeight, (_) => updateCompatibleCarTypes());
    ever(gateWidth, (_) => updateCompatibleCarTypes());
    ever(garageDepth, (_) => updateCompatibleCarTypes());
    ever(priceController, (_) => calculateSuggestedPrices());
  }

  bool validateCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return validateStepOne();
      case 1:
        return validateStepTwo();
      case 2:
        return validateStepThree();
      case 3:
        return validateStepFour();
      case 4:
        return validateStepFive();
      default:
        return false;
    }
  }

  bool validateStepOne() {
    final isNameValid = validateName();
    final isDescriptionValid = validateDescription();
    return isNameValid && isDescriptionValid;
  }

  bool validateStepTwo() {
    return validateImage();
  }

  bool validateStepThree() {
    return true; // validateOperatingHours();
  }

  bool validateStepFour() {
    return validateTags();
  }

  bool validateStepFive() {
    final isPriceValid = validatePrice();
    return isPriceValid;
  }

  void fillAddressFromLandlord() {
    final landlordAddress = landlord.address;

    postalCodeController.text = landlordAddress.postalCode ?? '';
    streetController.text = landlordAddress.street ?? '';
    numberController.text = landlordAddress.number ?? '';
    cityController.text = landlordAddress.city ?? '';
    stateController.text = landlordAddress.state ?? '';
    countryController.text = landlordAddress.country ?? '';
    complementController.text = landlordAddress.complement ?? '';
  }

  Future<void> getGalleryImages() async {
    if (selectedGalleryImages.isEmpty) {
      final files = await _imageService.pickImages();

      final xFiles = files.map((file) => XFile(file.path)).toList();

      if (xFiles.isNotEmpty) {
        selectedGalleryImages.clear();
        selectedGalleryImages.addAll(xFiles);
      } else {
        // Nenhuma imagem selecionada
      }
    }
  }

  Future<List<ImageBlurHash>> uploadImages() async {
    final blurhashImages = <ImageBlurHash>[];

    for (final selectedImage in selectedGalleryImages) {
      final image = await _imageService.buildImageBlurHash(
        selectedImage,
        'users',
      );

      if (image != null) {
        blurhashImages.add(image);
      }
    }

    return blurhashImages;
  }

  // void addSelectedImage(File image) {
  //   selectedImages.add(image);
  // }
  //
  // void removeSelectedImage(File image) {
  //   selectedImages.remove(image);
  // }

  void fetchAddressDetails() async {
    final postalCode = postalCodeController.text;
    if (postalCode.isNotEmpty) {
      final addressDetails =
          await _addressService.getAddressDetails(postalCode);
      if (addressDetails != null) {
        streetController.text = addressDetails['logradouro'] ?? '';
        cityController.text = addressDetails['localidade'] ?? '';
        stateController.text = addressDetails['uf'] ?? '';
        countryController.text = 'Brasil';
      }
    }
  }

  Address getAddressFromFields() {
    final postalCode = postalCodeController.text;
    final street = streetController.text;
    final number = numberController.text;
    final city = cityController.text;
    final state = stateController.text;
    final country = countryController.text;

    return Address(
      postalCode: postalCode,
      street: street,
      number: number,
      city: city,
      state: state,
      country: country,
    );
  }

  void updateCompatibleCarTypes() {
    compatibleCarTypes.value = _garageService.getCompatibleCarTypes(
      gateHeight.value,
      gateWidth.value,
      garageDepth.value,
    );
  }

  Future<void> save() async {
    loading(true);

    selectedImagesBlurhash.value = await uploadImages();

    if (selectedImagesBlurhash.isEmpty) return;

    final name = nameController.text;
    final price = priceController.value;
    final description = descriptionController.text;
    final postalCode = postalCodeController.text;
    final street = streetController.text;
    final number = numberController.text;
    final city = cityController.text;
    final state = stateController.text;
    final country = countryController.text;
    final complement = complementController.text;
    final address = getAddressFromFields();
    final location = await _addressService.getCoordinatesFromAddress(address);

    if (location == null) {
      addressError.value = 'Coordenadas não encontradas. Tente novamente.';
      Get.snackbar('Erro inesperado', addressError.value);
      return;
    }

    final isAutomatic = isAutomaticController.value;

    final parking = Parking(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: name,
      pricePerHour: price,
      isAvailable: true,
      tags: parkingTags,
      description: description,
      images: selectedImagesBlurhash,
      ownerId: _authRepository.authUser!.uid,
      type: parkingType.value!.name,
      // operatingHours: OperatingHours(daysAndHours: selectedOperatingHours),
      location: location,
      address: Address(
        postalCode: postalCode,
        street: street,
        number: number,
        city: city,
        state: state,
        country: country,
        complement: complement,
      ),
      gateHeight: gateHeight.value,
      gateWidth: gateWidth.value,
      garageDepth: garageDepth.value,
      isAutomatic: isAutomatic,
      isOpen: false,
    );

    // await _authController.registerUserType();

    // final List<File> selectedImageFiles =
    //     selectedGalleryImages.map((xFile) => File(xFile.path)).toList();

    await _repository.save(parking);

    loading(false);
  }

  bool isTypeSelected(ParkingType type) {
    return parkingType.value == type;
  }

  void selectType(ParkingType type) {
    parkingType.value = type;
  }

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  bool validateImage() {
    final isValid = selectedGalleryImages.isNotEmpty;
    imageError.value = isValid ? '' : 'Selecione uma imagem';
    return isValid;
  }

  bool validateTags() {
    final isValid = parkingTags.isNotEmpty;
    tagsError.value = isValid ? '' : 'Selecione pelo menos uma tag';
    return isValid;
  }

  bool validateName() {
    final isValid = nameController.text.isNotEmpty;
    nameError.value =
        isValid ? '' : 'Nome do estacionamento não pode estar vazio';
    return isValid;
  }

  bool validatePrice() {
    final isValid = priceController >= 7;
    priceError.value = isValid ? '' : 'Preço inválido';
    return true;
  }

  bool validateDescription() {
    final isValid = descriptionController.text.isNotEmpty;
    descriptionError.value = isValid ? '' : 'Descrição não pode estar vazia';
    return isValid;
  }

  // bool validateOperatingHours() {
  //   if (selectedOperatingHours.isEmpty) {
  //     operatingHoursError.value =
  //         'Selecione pelo menos um dia de funcionamento';
  //     return false;
  //   }
  //
  //   for (final day in selectedOperatingHours.keys) {
  //     final hours = selectedOperatingHours[day]!;
  //     if (hours.isEmpty) {
  //       operatingHoursError.value = 'Selecione pelo menos uma hora para $day';
  //       return false;
  //     }
  //   }
  //
  //   operatingHoursError.value = '';
  //   return true;
  // }

  bool validateCoordinates() {
    final isValid = coordinatesController.text.isNotEmpty;
    coordinatesError.value =
        isValid ? '' : 'Coordenadas não podem estar vazias';
    return true;
  }

  bool validatePostalCode() {
    final isValid = postalCodeController.text.isNotEmpty;
    postalCodeError.value = isValid ? '' : 'CEP não pode estar vazio';
    return isValid;
  }

  bool validateStreet() {
    final isValid = streetController.text.isNotEmpty;
    streetError.value = isValid ? '' : 'Rua não pode estar vazia';
    return isValid;
  }

  bool validateNumber() {
    final isValid = numberController.text.isNotEmpty;
    numberError.value = isValid ? '' : 'Número não pode estar vazio';
    return isValid;
  }

  bool validateCity() {
    final isValid = cityController.text.isNotEmpty;
    cityError.value = isValid ? '' : 'Cidade não pode estar vazia';
    return isValid;
  }

  bool validateState() {
    final isValid = stateController.text.isNotEmpty;
    stateError.value = isValid ? '' : 'Estado não pode estar vazio';
    return isValid;
  }

  bool validateCountry() {
    final isValid = countryController.text.isNotEmpty;
    countryError.value = isValid ? '' : 'País não pode estar vazio';
    return isValid;
  }

  bool validateComplement() {
    final isValid = complementController.text.isNotEmpty;
    complementError.value = isValid ? '' : 'Complemento não pode estar vazio';
    return isValid;
  }

  bool validateGate() {
    // final gateHeightText = gateHeightController.text;
    // final gateWidthText = gateWidthController.text;
    // final garageDepthText = garageDepthController.text;
    //
    // final isHeightValid =
    //     gateHeightText.isNotEmpty && double.tryParse(gateHeightText) != null;
    // final isWidthValid =
    //     gateWidthText.isNotEmpty && double.tryParse(gateWidthText) != null;
    // final isDepthValid =
    //     garageDepthText.isNotEmpty && double.tryParse(gateWidthText) != null;
    //
    // if (!isHeightValid) {
    //   gateHeightError.value = 'Altura do portão inválida';
    // } else {
    //   gateHeightError.value = '';
    // }
    //
    // if (!isWidthValid) {
    //   gateWidthError.value = 'Largura do portão inválida';
    // } else {
    //   gateWidthError.value = '';
    // }
    //
    // if (!isDepthValid) {
    //   garageDepthError.value = 'Profundidade da vaga inválida';
    // } else {
    //   garageDepthError.value = '';
    // }

    return true;
  }

  final RxMap<String, double> suggestedPrices = <String, double>{}.obs;

  void calculateSuggestedPrices() {
    suggestedPrices.value =
        PriceService.calculateSuggestedPrices(priceController.value);
  }
}
