import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/address/controllers/address_edit_controller.dart';
import 'package:vagali/features/auth/repositories/auth_repository.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/parking/models/parking_type.dart';
import 'package:vagali/features/parking/models/price.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/reservation/models/reservation_type.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/garage_service.dart';
import 'package:vagali/services/image_service.dart';
import 'package:vagali/services/price_service.dart';
import 'package:vagali/services/schedule_service.dart';

class ParkingEditController extends GetxController {
  ParkingEditController(this.originalParking) {
    if (originalParking != null) {
      parking = originalParking!.copyWith();
    }
  }

  Parking? originalParking;
  late Parking parking;
  final User landlord = Get.find();
  final ParkingRepository _repository = ParkingRepository();
  final AuthRepository _authRepository = Get.find();
  final addressController = Get.put(AddressEditController());

  final _imageService = ImageService();
  final _garageService = GarageService();
  final _priceService = PriceService();
  final scheduleService = ScheduleService();

  final currentParking = Rx<Parking?>(null);

  RxBool get hasCurrentUser => (currentParking.value != null).obs;

  // void setParkingToEdit(Parking parking) {
  //   currentParking.value = parking;
  //   fillFormWithParkingData();
  // }
  //
  // Future<void> fillFormWithParkingData() async {
  //   parking = currentParking.value!;
  //
  //   nameController.value = parking.name;
  //   descriptionController.value = parking.description;
  //   // coordinatesController.value = parking.name;
  //
  //   postalCodeController.value = parking.address.postalCode;
  //   streetController.value = parking.address.street;
  //   numberController.value = parking.address.number;
  //   cityController.value = parking.address.city;
  //   stateController.value = parking.address.state;
  //   countryController.value = parking.address.country;
  //   complementController.value = parking.address.complement ?? '';
  //   selectedImagesBlurhash.value = parking.images;
  //   selectedGalleryImages.value =
  //       await _imageService.downloadAndSaveImagesToLocal(parking.images);
  //
  //   pricePerHourController.value = parking.price.hour.toString();
  //   pricePerSixHoursController.value = parking.price.sixHours.toString();
  //   pricePerTwelveHoursController.value = parking.price.twelveHours.toString();
  //   pricePerDayController.value = parking.price.day.toString();
  //   pricePerMonthController.value = parking.price.month.toString();
  //   gateHeight.value = parking.gateHeight.toDouble();
  //   gateWidth.value = parking.gateWidth.toDouble();
  //   garageDepth.value = parking.garageDepth.toDouble();
  //
  //   parkingTags.value = parking.tags;
  // }

  final currentStep = 0.obs;
  final selectedGalleryImages = <XFile>[].obs;
  final selectedImagesBlurhash = <ImageBlurHash>[].obs;
  final nameController = ''.obs;
  final descriptionController = ''.obs;

  final coordinatesController = ''.obs;
  final postalCodeController = ''.obs;
  final streetController = ''.obs;
  final numberController = ''.obs;
  final countyController = ''.obs;
  final cityController = ''.obs;
  final stateController = ''.obs;
  final countryController = ''.obs;
  final complementController = ''.obs;

  final parkingType = Rx<ParkingType?>(null);
  final parkingTags = <ParkingTag>[].obs;
  final gateHeight = 300.0.obs;
  final gateWidth = 300.0.obs;
  final garageDepth = 1000.0.obs;
  final isAutomaticController = RxBool(false);
  final compatibleCarTypes = <VehicleType>[].obs;

  final reservationTypeController = ''.obs;
  final isFlexible = true.obs;

  final pricePerHourController = ''.obs;
  final pricePerSixHoursController = ''.obs;
  final pricePerTwelveHoursController = ''.obs;
  final pricePerDayController = ''.obs;
  final pricePerMonthController = ''.obs;

  RxString get imageError =>
      (isImageValid.isTrue ? '' : 'Selecione uma imagem').obs;

  RxString get nameError =>
      (isNameValid.isTrue ? '' : 'Nome do estacionamento não pode estar vazio')
          .obs;

  RxString get tagsError =>
      (isTagsValid.isTrue ? '' : 'Selecione pelo menos uma tag').obs;

  RxString get priceError {
    if (!isPricePerHourValid.isTrue) {
      return 'O preço por hora deve ser maior ou igual a R\$3,00'.obs;
    } else if (!isPricePerSixHoursValid.isTrue) {
      return 'O preço por 6 horas deve ser maior ou igual a R\$8,00 e superar o preço por hora'
          .obs;
    } else if (!isPricePerTwelveHoursValid.isTrue) {
      return 'O preço por 12 horas deve ser maior ou igual a R\$12,00 e superar o preço por 6 horas'
          .obs;
    } else if (!isPricePerDayValid.isTrue) {
      return 'O preço por dia deve ser maior ou igual a R\$15,00 e superar o preço por 12 horas'
          .obs;
    } else if (!isPricePerMonthValid.isTrue) {
      return 'O preço por mês deve ser maior ou igual a R\$90,00'.obs;
    } else {
      return ''.obs;
    }
  }

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
    selectType(parkingTypes[1]); // Casas
    updateCompatibleCarTypes();

    pricePerHourController.value = 5.toString();
    calculateSuggestedPrices();
    ever(pricePerHourController, (_) => calculateSuggestedPrices());
    ever(gateHeight, (_) => updateCompatibleCarTypes());
    ever(gateWidth, (_) => updateCompatibleCarTypes());
    ever(garageDepth, (_) => updateCompatibleCarTypes());
  }

  RxBool validateCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return (addressController.isAddressValid.isTrue).obs;
      case 1:
        return (isNameValid.isTrue && isDescriptionValid.isTrue).obs;
      case 2:
        return isImageValid;
      case 3:
        return isGateValid;
      case 4:
        return isTagsValid;
      case 5:
        return isPriceValid;
      default:
        return false.obs;
    }
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

  RxBool get isNameValid {
    return (nameController.value.isNotEmpty && nameController.value.length > 3)
        .obs;
  }

  RxBool get isDescriptionValid => descriptionController.value.isNotEmpty.obs;

  RxBool get isImageValid => selectedGalleryImages.isNotEmpty.obs;

  RxBool get isTagsValid => parkingTags.isNotEmpty.obs;

  RxBool get isPriceValid => (isPricePerHourValid.isTrue &&
          isPricePerSixHoursValid.isTrue &&
          isPricePerTwelveHoursValid.isTrue &&
          isPricePerDayValid.isTrue &&
          isPricePerMonthValid.isTrue)
      .obs;

  RxBool get isPricePerHourValid =>
      _isValidPrice(pricePerHourController.value, 3);

  RxBool get isPricePerSixHoursValid => _isValidPrice(
      pricePerSixHoursController.value,
      double.tryParse(pricePerHourController.value) ?? 0,
      minDifference: 6,
      minValue: 6);

  RxBool get isPricePerTwelveHoursValid => _isValidPrice(
      pricePerTwelveHoursController.value,
      double.tryParse(pricePerSixHoursController.value) ?? 0,
      minDifference: 6,
      minValue: 9);

  RxBool get isPricePerDayValid => _isValidPrice(pricePerDayController.value,
      double.tryParse(pricePerTwelveHoursController.value) ?? 0,
      minDifference: 9, minValue: 12);

  RxBool get isPricePerMonthValid =>
      _isValidPrice(pricePerMonthController.value, 0, minValue: 90);

  RxBool _isValidPrice(String price, double previousPrice,
      {double minDifference = 0, double minValue = 0}) {
    final value = double.tryParse(price) ?? 0;
    return (price.isNotEmpty &&
            value >= previousPrice &&
            value >= minDifference)
        ? (value >= minValue).obs
        : false.obs;
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

  RxBool get isCoordinatesValid => coordinatesController.value.isNotEmpty.obs;

  RxBool get isPostalCodeValid => postalCodeController.value.isNotEmpty.obs;

  RxBool get isStreetValid => streetController.value.isNotEmpty.obs;

  RxBool get isNumberValid => numberController.value.isNotEmpty.obs;

  RxBool get isCityValid => cityController.value.isNotEmpty.obs;

  RxBool get isStateValid => stateController.value.isNotEmpty.obs;

  RxBool get isCountryValid => countryController.value.isNotEmpty.obs;

  RxBool get isComplementValid => complementController.value.isNotEmpty.obs;

  RxBool get isGateValid {
    return true.obs;
  }

  Future<void> pickImages(ImageSource source) async {
    if (source == ImageSource.camera) {
      await _pickImageFromCamera();
    } else {
      await pickImagesFromGallery();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await _imageService.pickImage(ImageSource.camera);

    if (file != null) {
      final xFile = XFile(file.path);
      selectedGalleryImages.add(xFile);

      _buildImageBlurhash(xFile);
    }
  }

  Future<void> pickImagesFromGallery() async {
    if (selectedGalleryImages.isEmpty) {
      final files = await _imageService.pickImages();

      final xFiles = files.map((file) => XFile(file.path)).toList();

      if (xFiles.isNotEmpty) {
        selectedGalleryImages.clear();
        selectedGalleryImages.addAll(xFiles);

        for (final galleryImage in selectedGalleryImages) {
          _buildImageBlurhash(galleryImage);
        }
      } else {
        // Nenhuma imagem selecionada
      }
    }
  }

  Future<void> _buildImageBlurhash(XFile image) async {
    final blurhash = await _getBlurhash(image);
    final imageUrl = await _getImageUrls(image);
    if (blurhash != null && imageUrl != null) {
      final imageBlurhash = ImageBlurHash(image: imageUrl, blurHash: blurhash);
      selectedImagesBlurhash.add(imageBlurhash);
    }
  }

  // void addSelectedImage(File image) {
  //   selectedImages.add(image);
  // }
  //

  void removeSelectedImage(XFile image) => selectedGalleryImages.remove(image);

  void fetchAddressDetails() async {
    if (postalCodeController.value.isNotEmpty) {
      final addressDetails = await addressController.getAddressDetails();
      if (addressDetails != null) {
        streetController.value = addressDetails['logradouro'] ?? '';
        countyController.value = addressDetails['bairro'] ?? '';
        cityController.value = addressDetails['localidade'] ?? '';
        stateController.value = addressDetails['uf'] ?? '';
        countryController.value = 'Brasil';
      }
    }
  }

  // Address getAddressFromFields() {
  //   return Address(
  //     postalCode: postalCodeController.value,
  //     street: streetController.value,
  //     number: numberController.value,
  //     county: numberController.value,
  //     city: cityController.value,
  //     state: stateController.value,
  //     country: countryController.value,
  //   );
  // }

  void updateCompatibleCarTypes() {
    compatibleCarTypes.value = _garageService.getCompatibleCarTypes(
      gateHeight.value,
      gateWidth.value,
      garageDepth.value,
    );
  }

  final isPriceLoading = false.obs;

  Future<void> calculateSuggestedPrices() async {
    isPriceLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    final price = double.tryParse(pricePerHourController.value);
    if (price != null) {
      final suggestedPrices = _priceService.calculateSuggestedPrices(price);
      pricePerSixHoursController.value = suggestedPrices.sixHours.toString();
      pricePerTwelveHoursController.value =
          suggestedPrices.twelveHours.toString();
      pricePerDayController.value = suggestedPrices.day.toString();
      pricePerMonthController.value = suggestedPrices.month.toString();
    }
    isPriceLoading.value = false;
  }

  Future<SaveResult> save() async {
    loading(true);

    final location = await addressController.getCoordinatesFromAddress();

    if (location == null) {
      addressError.value = 'Coordenadas não encontradas. Tente novamente.';
      Get.snackbar('Erro inesperado', addressError.value);
      return SaveResult.failed;
    }

    if (selectedImagesBlurhash.isEmpty) return SaveResult.failed;

    final isAutomatic = isAutomaticController.value;
    parking = Parking(
      id: _repository.generateId(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: nameController.value,
      price: Price(
        hour: double.parse(pricePerHourController.value),
        sixHours: double.parse(pricePerSixHoursController.value),
        twelveHours: double.parse(pricePerTwelveHoursController.value),
        day: double.parse(pricePerDayController.value),
        month: double.parse(pricePerMonthController.value),
      ),
      isAvailable: true,
      tags: parkingTags,
      description: descriptionController.value,
      images: selectedImagesBlurhash,
      userId: _authRepository.authUser!.uid,
      type: parkingType.value!.name,
      // operatingHours: OperatingHours(daysAndHours: selectedOperatingHours),
      location: location,
      address: addressController.address,
      gateHeight: gateHeight.value,
      gateWidth: gateWidth.value,
      garageDepth: garageDepth.value,
      isAutomatic: isAutomatic,
      isOpen: false,
      // reservationType: reservationTypeController.value,
      reservationType: ReservationType.flex,
    );

    // await _authController.registerUserType();

    // final List<File> selectedImageFiles =
    //     selectedGalleryImages.map((xFile) => File(xFile.path)).toList();

    final result = await _repository.save(parking, docId: parking.id);

    loading(false);

    return result;
  }

  Future<SaveResult> updateParking() async {
    print('NEW NAME PARKING KKKKKK ${parking.name} sahdusahdusahdu');
    return await _repository.update(parking);
  }

  Future<String?> _getImageUrls(XFile file) async {
    final url = await _imageService.uploadImage(file, 'parkings');

    return url;
  }

  Future<String?> _getBlurhash(XFile file) async {
    final blurhash = await _imageService.getBlurhash(file);

    return blurhash;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
