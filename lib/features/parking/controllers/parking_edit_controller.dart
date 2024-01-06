import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/models/parking_type.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/parking/models/price.dart';
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

  final _imageService = ImageService();
  final _addressService = AddressService();
  final _garageService = GarageService();
  final scheduleService = ScheduleService();

  final currentStep = 0.obs;
  final selectedGalleryImages = <XFile>[].obs;
  final selectedImagesBlurhash = <ImageBlurHash>[].obs;

  final name = ''.obs;
  final description = ''.obs;

  final coordinates = ''.obs;
  final postalCode = ''.obs;
  final street = ''.obs;
  final number = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final country = ''.obs;
  final complement = ''.obs;

  // final List<File> imageFiles = <File>[];
  final parkingType = Rx<ParkingType?>(null);
  final parkingTags = <ParkingTag>[].obs;
  final gateHeight = 3.0.obs;
  final gateWidth = 3.0.obs;
  final garageDepth = 6.0.obs;
  final isAutomaticController = RxBool(false);
  final compatibleCarTypes = <VehicleType>[].obs;

  final reservationTypeController = TextEditingController().obs;
  final isFlexible = false.obs;

  final pricePerHourController = TextEditingController().obs;
  final pricePerSixHoursController = TextEditingController().obs;
  final pricePerTwelveHoursController = TextEditingController().obs;
  final pricePerDayController = TextEditingController().obs;
  final pricePerMonthController = TextEditingController().obs;

  RxString get imageError =>
      (isImageValid.isTrue ? '' : 'Selecione uma imagem').obs;

  RxString get nameError =>
      (isNameValid.isTrue ? '' : 'Nome do estacionamento não pode estar vazio')
          .obs;

  RxString get tagsError =>
      (isTagsValid.isTrue ? '' : 'Selecione pelo menos uma tag').obs;

  RxString get priceError => (isPriceValid.isTrue ? '' : 'Preço inválido').obs;

  RxString get descriptionError =>
      (isDescriptionValid.isTrue ? '' : 'Descrição não pode estar vazia').obs;

  // final operatingHoursError = RxString('');
  RxString get coordinatesError =>
      (isCoordinatesValid.isTrue ? '' : 'Coordenadas não podem estar vazias')
          .obs;

  RxString get addressError =>
      (isGateValid.isTrue ? '' : 'Erro no endereço').obs;

  RxString get gateHeightError => ''.obs;

  RxString get gateWidthError => ''.obs;

  RxString get garageDepthError => ''.obs;

  final showErrors = false.obs;
  final loading = false.obs;

  final totalSteps = 5;

  @override
  void onInit() {
    super.onInit();
    fillAddressFromLandlord();

    /// Modificar em versoes posteriores
    selectType(parkingTypes[1]); // Casas
    updateCompatibleCarTypes();

    pricePerHourController.value.addListener(() => calculateSuggestedPrices());
    reservationTypeController.value.addListener(() {
      if (reservationTypeController.value.text == 'Flexível') {
        isFlexible.value = true;
      } else {
        isFlexible.value = false;
      }
    });

    ever(gateHeight, (_) => updateCompatibleCarTypes());
    ever(gateWidth, (_) => updateCompatibleCarTypes());
    ever(garageDepth, (_) => updateCompatibleCarTypes());
  }

  RxBool validateCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return validateStepOne().obs;
      case 1:
        return validateStepTwo().obs;
      case 2:
        return validateStepThree().obs;
      case 3:
        return validateStepFour().obs;
      case 4:
        return validateStepFive().obs;
      default:
        return false.obs;
    }
  }

  bool validateStepOne() => isNameValid.value && isDescriptionValid.value;

  bool validateStepTwo() => isImageValid.value;

  bool validateStepThree() {
    return true; // validateOperatingHours();
  }

  bool validateStepFour() {
    return isTagsValid.value;
  }

  bool validateStepFive() {
    return isPriceValid.value;
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

  RxBool get isImageValid => selectedGalleryImages.isNotEmpty.obs;

  RxBool get isNameValid => name.isNotEmpty.obs;

  RxBool get isTagsValid => parkingTags.isNotEmpty.obs;

  RxBool get isPriceValid {
    final price = double.tryParse(pricePerHourController.value.text);
    if (price != null) {
      return (price >= 7).obs;
    }
    return false.obs;
  }

  RxBool get isDescriptionValid => description.value.isNotEmpty.obs;

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
  RxBool get isCoordinatesValid => coordinates.value.isNotEmpty.obs;

  RxBool get isPostalCodeValid => postalCode.value.isNotEmpty.obs;

  RxBool get isStreetValid => street.value.isNotEmpty.obs;

  RxBool get isNumberValid => number.value.isNotEmpty.obs;

  RxBool get isCityValid => city.value.isNotEmpty.obs;

  RxBool get isStateValid => state.value.isNotEmpty.obs;

  RxBool get isCountryValid => country.value.isNotEmpty.obs;

  RxBool get isComplementValid => complement.value.isNotEmpty.obs;

  RxBool get isGateValid {
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

    return true.obs;
  }

  void fillAddressFromLandlord() {
    final landlordAddress = landlord.address;

    postalCode.value = landlordAddress.postalCode ?? '';
    street.value = landlordAddress.street ?? '';
    number.value = landlordAddress.number ?? '';
    city.value = landlordAddress.city ?? '';
    state.value = landlordAddress.state ?? '';
    country.value = landlordAddress.country ?? '';
    complement.value = landlordAddress.complement ?? '';
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
    if (postalCode.isNotEmpty) {
      final addressDetails =
          await _addressService.getAddressDetails(postalCode.value);
      if (addressDetails != null) {
        street.value = addressDetails['logradouro'] ?? '';
        city.value = addressDetails['localidade'] ?? '';
        state.value = addressDetails['uf'] ?? '';
        country.value = 'Brasil';
      }
    }
  }

  Address getAddressFromFields() {
    return Address(
      postalCode: postalCode.value,
      street: street.value,
      number: number.value,
      city: city.value,
      state: state.value,
      country: country.value,
    );
  }

  void updateCompatibleCarTypes() {
    compatibleCarTypes.value = _garageService.getCompatibleCarTypes(
      gateHeight.value,
      gateWidth.value,
      garageDepth.value,
    );
  }

  void calculateSuggestedPrices() {
    final price = double.tryParse(pricePerHourController.value.text);
    if (price != null) {
      final suggestedPrices = PriceService.calculateSuggestedPrices(price);
      pricePerSixHoursController.value.text =
          suggestedPrices.sixHours.toString();
      pricePerTwelveHoursController.value.text =
          suggestedPrices.twelveHours.toString();
      pricePerDayController.value.text = suggestedPrices.day.toString();
      pricePerMonthController.value.text = suggestedPrices.month.toString();
    }
  }

  Future<void> save() async {
    loading(true);

    selectedImagesBlurhash.value = await uploadImages();

    if (selectedImagesBlurhash.isEmpty) return;

    // final name = nameController.text;
    // final price = double.parse(pricePerHourController.value.text);
    // final description = descriptionController.text;
    // final postalCode = postalCodeController.text;
    // final street = streetController.text;
    // final number = numberController.text;
    // final city = cityController.text;
    // final state = stateController.text;
    // final country = countryController.text;
    // final complement = complementController.text;
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
      name: name.value,
      price: Price(
        month: 0,
      ),
      isAvailable: true,
      tags: parkingTags,
      description: description.value,
      images: selectedImagesBlurhash,
      ownerId: _authRepository.authUser!.uid,
      type: parkingType.value!.name,
      // operatingHours: OperatingHours(daysAndHours: selectedOperatingHours),
      location: location,
      address: Address(
        postalCode: postalCode.value,
        street: street.value,
        number: number.value,
        city: city.value,
        state: state.value,
        country: country.value,
        complement: complement.value,
      ),
      gateHeight: gateHeight.value,
      gateWidth: gateWidth.value,
      garageDepth: garageDepth.value,
      isAutomatic: isAutomatic,
      isOpen: false,
      reservationType: reservationTypeController.value.text,
    );

    // await _authController.registerUserType();

    // final List<File> selectedImageFiles =
    //     selectedGalleryImages.map((xFile) => File(xFile.path)).toList();

    await _repository.save(parking);

    loading(false);
  }
}
