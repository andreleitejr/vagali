import 'package:get/get.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/features/item/repositories/item_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/image_blurhash.dart';

class TenantController extends GetxController {
  final User tenant = Get.find();

  final _itemRepository = Get.find<ItemRepository>();

  final items = <Item>[].obs;

  // final vehicles = <Vehicle>[].obs;

  String get name => tenant.firstName;

  ImageBlurHash get image => tenant.image;
  final loading = false.obs;

  Future<void> _fetchItems() async {
    print(' HUSDHUASDHASUDHASDUHAUAHSDAUDSHAUDHADSU TENANT ID ${tenant.id!}');
    final tenantItems = await _itemRepository.getAll(userId: tenant.id!);

    print('HUSADHASUHADSUDHUDASHDSUHUHASDUDHUHUHDASU TENANT ITENS ${tenantItems.length}');
    items.addAll(tenantItems);
  }

  @override
  Future<void> onInit() async {
    loading(true);
    await _fetchItems();

    loading(false);
    super.onInit();
  }
}
