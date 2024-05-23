// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vagali/apps/tenant/features/vehicle/models/vehicle.dart';
// import 'package:vagali/apps/tenant/features/vehicle/repositories/vehicle_repository.dart';
// import 'package:vagali/models/image_blurhash.dart';
// import 'package:vagali/services/image_service.dart';
//
// class VehicleEditController extends GetxController {
//   final _repository = Get.put(VehicleRepository());
//
//   final _imageService = ImageService();
//
//   var imageBlurhash = Rx<ImageBlurHash?>(null);
//   final imageFileController = Rx<XFile?>(null);
//   final vehicleTypeController = ''.obs;
//   final licensePlateController = ''.obs;
//   final yearController = ''.obs;
//   final colorController = ''.obs;
//   final brandController = ''.obs;
//   final modelController = ''.obs;
//   final registrationStateController = ''.obs;
//
//   final RxString vehicleTypeError = ''.obs;
//   final RxString licensePlateError = ''.obs;
//   final RxString yearError = ''.obs;
//   final RxString colorError = ''.obs;
//   final RxString brandError = ''.obs;
//   final RxString modelError = ''.obs;
//   final RxString registrationStateError = ''.obs;
//   final imageError = ''.obs;
//
//   var loading = false.obs;
//   final showErrors = false.obs;
//
//   String getError(RxString error) {
//     if (showErrors.isTrue) {
//       return error.value;
//     }
//     return '';
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     final imageUrl = await _imageService.pickImage(source);
//
//     if (imageUrl != null) {
//       imageFileController.value = imageUrl;
//     } else {
//       imageError.value = 'Falha ao carregar a imagem';
//     }
//   }
//
//   Future<ImageBlurHash?> uploadImage() async {
//     final image = await _imageService.buildImageBlurHash(
//       imageFileController.value!,
//       'users',
//     );
//
//     if (image == null) {
//       imageError.value = 'Falha ao carregar a imagem';
//     }
//
//     return image;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     ever(licensePlateController, (callback) => validateLicensePlate());
//     ever(yearController, (callback) => validateYear());
//     ever(colorController, (callback) => validateColor());
//     ever(brandController, (callback) => validateBrand());
//     ever(modelController, (callback) => validateModel());
//     ever(
//         registrationStateController, (callback) => validateRegistrationState());
//   }
//
//   bool validateLicensePlate() {
//     final isValid = licensePlateController.value.isNotEmpty;
//     licensePlateError.value =
//         isValid ? '' : 'Placa do veículo não pode estar vazia';
//     return isValid;
//   }
//
//   bool validateYear() {
//     final yearText = yearController.value;
//     final currentYear = DateTime.now().year;
//
//     final inputYear = int.tryParse(yearText);
//
//     final isValid = inputYear != null && inputYear <= currentYear;
//
//     if (isValid) {
//       yearError.value = '';
//     } else {
//       yearError.value = 'Ano do veículo inválido';
//       yearController.value = currentYear.toString();
//     }
//
//     showErrors(true);
//     return isValid;
//   }
//
//   bool validateColor() {
//     final isValid = colorController.value.isNotEmpty;
//     colorError.value = isValid ? '' : 'Cor do veículo não pode estar vazia';
//     return isValid;
//   }
//
//   bool validateBrand() {
//     final isValid = brandController.value.isNotEmpty;
//     brandError.value = isValid ? '' : 'Marca do veículo não pode estar vazia';
//     return isValid;
//   }
//
//   bool validateModel() {
//     final isValid = modelController.value.isNotEmpty;
//     modelError.value = isValid ? '' : 'Modelo do veículo não pode estar vazio';
//     return isValid;
//   }
//
//   bool validateRegistrationState() {
//     final isValid = registrationStateController.value.isNotEmpty;
//     registrationStateError.value =
//         isValid ? '' : 'Estado de registro não pode estar vazio';
//     return isValid;
//   }
//
//   bool isValid() {
//     final isLicensePlateValid = validateLicensePlate();
//     final isYearValid = validateYear();
//     final isColorValid = validateColor();
//     final isBrandValid = validateBrand();
//     final isModelValid = validateModel();
//     final isRegistrationStateValid = validateRegistrationState();
//
//     return isLicensePlateValid &&
//         isYearValid &&
//         isColorValid &&
//         isBrandValid &&
//         isModelValid &&
//         isRegistrationStateValid;
//   }
//
//   Future<String?> createVehicleAndGetId() async {
//     loading(true);
//
//     imageBlurhash.value = await uploadImage();
//
//     if (imageBlurhash.value == null) return null;
//
//     final vehicleType = vehicleTypeController.value;
//     final licensePlate = licensePlateController.value;
//     final year = yearController.value;
//     final color = colorController.value;
//     final brand = brandController.value;
//     final model = modelController.value;
//     final registrationState = registrationStateController.value;
//
//     final vehicle = Vehicle(
//       image: imageBlurhash.value!,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       vehicleType: vehicleType,
//       licensePlate: licensePlate,
//       year: year,
//       color: color,
//       brand: brand,
//       model: model,
//       registrationState: registrationState,
//     );
//
//     final vehicleId = await _repository.saveAndGetId(vehicle);
//
//     loading(false);
//
//     return vehicleId;
//   }
//
//   Future<bool> save() async {
//     if (!isValid()) {
//       return false;
//     }
//
//     loading(true);
//
//     imageBlurhash.value = await uploadImage();
//
//     if (imageBlurhash.value == null) return false;
//
//     final vehicleType = vehicleTypeController.value;
//     final licensePlate = licensePlateController.value;
//     final year = yearController.value;
//     final color = colorController.value;
//     final brand = brandController.value;
//     final model = modelController.value;
//     final registrationState = registrationStateController.value;
//
//     final vehicle = Vehicle(
//       image: imageBlurhash.value!,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       vehicleType: vehicleType,
//       licensePlate: licensePlate,
//       year: year,
//       color: color,
//       brand: brand,
//       model: model,
//       registrationState: registrationState,
//     );
//
//     try {
//       await _repository.save(vehicle);
//
//       loading(false);
//       return true;
//     } catch (error) {
//       loading(false);
//       debugPrint('Erro ao criar veículo: $error');
//       return false;
//     }
//   }
// }
