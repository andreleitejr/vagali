// item_search_controller.dart

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/apps/tenant/features/vehicle/models/vehicle_type.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/stock.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/features/item/repositories/item_repository.dart';
import 'package:vagali/models/dimension.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/image_service.dart';

/// IMPLEMENTAR O SEARCH POSTERIORMENTE NA VERSAO 1.0.1

class ItemEditController extends GetxController {
  final ItemRepository repository = Get.find();
  final _imageService = ImageService();
  final loading = false.obs;
  final selectedItemType = Rx<ItemType?>(null);
  final selectedVehicleType = Rx<VehicleType?>(null);

  final imageBlurhash = Rx<ImageBlurHash?>(null);
  final imageFileController = Rx<XFile?>(null);
  final title = ''.obs;
  final description = ''.obs;
  final width = ''.obs;
  final height = ''.obs;
  final depth = ''.obs;

  /// VEHICLE INPUTS
  final vehicleTypeController = Rx<VehicleType?>(null);
  final licensePlateController = ''.obs;
  final yearController = ''.obs;
  final colorController = ''.obs;
  final brandController = ''.obs;
  final modelController = ''.obs;
  final registrationStateController = ''.obs;

  /// STOCK INPUTS
  final productQuantity = 0.obs;
  final productType = ''.obs;

  final vehicleTypeError = ''.obs;
  final licensePlateError = ''.obs;
  final yearError = ''.obs;
  final colorError = ''.obs;
  final brandError = ''.obs;
  final modelError = ''.obs;
  final registrationStateError = ''.obs;
  final imageError = ''.obs;

  Dimension get dimension => Dimension(
        width: double.parse(width.value),
        height: double.parse(height.value),
        depth: double.parse(depth.value),
      );

  final showErrors = false.obs;

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  @override
  void onInit() {
    super.onInit();
    ever(selectedItemType, (_) {
      selectedVehicleType.value = null;
    });
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

  Future<Item?> createVehicle() async {
    loading.value = true;
    imageBlurhash.value = await uploadImage();

    if (imageBlurhash.value == null) return null;

    final vehicleType = vehicleTypeController.value;
    final licensePlate = licensePlateController.value;
    final year = yearController.value;
    final color = colorController.value;
    final brand = brandController.value;
    final model = modelController.value;
    final registrationState = registrationStateController.value;

    final vehicle = Vehicle(
      image: imageBlurhash.value!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      vehicleType: vehicleType!.name,
      licensePlate: licensePlate,
      year: year,
      color: color,
      brand: brand,
      model: model,
      registrationState: registrationState,
      dimensions: vehicleType.dimension,
      weight: 20,
      material: 'Madeira',
    );

    final id = await await repository.saveAndGetId(vehicle);

    if (id != null) {
      vehicle.id = id;
      return vehicle;
    }

    loading.value = false;

    return null;
  }

  Future<Item?> createStock() async {
    loading.value = true;
    imageBlurhash.value = await uploadImage();

    if (imageBlurhash.value == null) return null;

    final stock = Stock(
      image: imageBlurhash.value!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dimensions: dimension,
      weight: 20,
      material: 'Madeira',
      productQuantity: productQuantity.value,
      productType: productType.value,
      title: title.value,
      description: description.value,
    );

    final id = await await repository.saveAndGetId(stock);

    if (id != null) {
      stock.id = id;
      return stock;
    }

    loading.value = false;

    return null;
  }
}
