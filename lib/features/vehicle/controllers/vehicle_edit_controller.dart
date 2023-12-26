import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/services/image_service.dart';

class VehicleEditController extends GetxController {
  final VehicleRepository _repository = Get.put(VehicleRepository());

  final ImageService _imageService = ImageService();

  var imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFileController = Rx<XFile?>(null);
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController registrationStateController =
      TextEditingController();

  final RxString vehicleTypeError = RxString('');
  final RxString licensePlateError = RxString('');
  final RxString yearError = RxString('');
  final RxString colorError = RxString('');
  final RxString brandError = RxString('');
  final RxString modelError = RxString('');
  final RxString registrationStateError = RxString('');
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

  @override
  void onInit() {
    super.onInit();
    licensePlateController.addListener(() {
      validateLicensePlate();
    });
    yearController.addListener(() {
      validateYear();
    });
    colorController.addListener(() {
      validateColor();
    });
    brandController.addListener(() {
      validateBrand();
    });
    modelController.addListener(() {
      validateModel();
    });
    registrationStateController.addListener(() {
      validateRegistrationState();
    });
  }

  bool validateLicensePlate() {
    final isValid = licensePlateController.text.isNotEmpty;
    licensePlateError.value =
        isValid ? '' : 'Placa do veículo não pode estar vazia';
    return isValid;
  }

  bool validateYear() {
    final yearText = yearController.text;
    final currentYear = DateTime.now().year;

    final inputYear = int.tryParse(yearText);

    final isValid = inputYear != null && inputYear <= currentYear;

    if (isValid) {
      yearError.value = '';
    } else {
      yearError.value = 'Ano do veículo inválido';
      yearController.text = currentYear.toString();
    }

    showErrors(true);
    return isValid;
  }

  bool validateColor() {
    final isValid = colorController.text.isNotEmpty;
    colorError.value = isValid ? '' : 'Cor do veículo não pode estar vazia';
    return isValid;
  }

  bool validateBrand() {
    final isValid = brandController.text.isNotEmpty;
    brandError.value = isValid ? '' : 'Marca do veículo não pode estar vazia';
    return isValid;
  }

  bool validateModel() {
    final isValid = modelController.text.isNotEmpty;
    modelError.value = isValid ? '' : 'Modelo do veículo não pode estar vazio';
    return isValid;
  }

  bool validateRegistrationState() {
    final isValid = registrationStateController.text.isNotEmpty;
    registrationStateError.value =
        isValid ? '' : 'Estado de registro não pode estar vazio';
    return isValid;
  }

  bool isValid() {
    final isLicensePlateValid = validateLicensePlate();
    final isYearValid = validateYear();
    final isColorValid = validateColor();
    final isBrandValid = validateBrand();
    final isModelValid = validateModel();
    final isRegistrationStateValid = validateRegistrationState();

    return isLicensePlateValid &&
        isYearValid &&
        isColorValid &&
        isBrandValid &&
        isModelValid &&
        isRegistrationStateValid;
  }

  Future<String?> createVehicleAndGetId() async {
    loading(true);

    imageBlurhash.value = await uploadImage();

    if (imageBlurhash.value == null) return null;

    final vehicleType = vehicleTypeController.text;
    final licensePlate = licensePlateController.text;
    final year = yearController.text;
    final color = colorController.text;
    final brand = brandController.text;
    final model = modelController.text;
    final registrationState = registrationStateController.text;

    final vehicle = Vehicle(
      image: imageBlurhash.value!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      vehicleType: vehicleType,
      licensePlate: licensePlate,
      year: year,
      color: color,
      brand: brand,
      model: model,
      registrationState: registrationState,
    );

    final vehicleId = await _repository.saveAndGetId(vehicle);

    loading(false);

    return vehicleId;
  }

  Future<bool> save() async {
    if (!isValid()) {
      return false;
    }

    loading(true);

    imageBlurhash.value = await uploadImage();

    if (imageBlurhash.value == null) return false;

    final vehicleType = vehicleTypeController.text;
    final licensePlate = licensePlateController.text;
    final year = yearController.text;
    final color = colorController.text;
    final brand = brandController.text;
    final model = modelController.text;
    final registrationState = registrationStateController.text;

    final vehicle = Vehicle(
      image: imageBlurhash.value!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      vehicleType: vehicleType,
      licensePlate: licensePlate,
      year: year,
      color: color,
      brand: brand,
      model: model,
      registrationState: registrationState,
    );

    try {
      await _repository.save(vehicle);

      loading(false);
      return true;
    } catch (error) {
      loading(false);
      debugPrint('Erro ao criar veículo: $error');
      return false;
    }
  }
}
