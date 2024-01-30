import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/views/item_edit_view.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/search_input.dart';

class ItemTypeListController extends GetxController {
  final searchText = ''.obs;

  RxList<ItemType> get filteredItemTypes => itemTypes
      .where((itemType) =>
          itemType.name!.clean.contains(searchText.value.clean) ||
          itemType.description!.clean.contains(searchText.value.clean))
      .toList()
      .obs;
}

class ItemTypeListView extends StatelessWidget {
  final Function(Item) onItemSelected;

  ItemTypeListView({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final controller = Get.put(ItemTypeListController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SearchInput(
            searchText: controller.searchText.value,
            hintText: 'Buscar objetos',
            onSearch: controller.searchText,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.filteredItemTypes.length,
              itemBuilder: (context, index) {
                final itemType = controller.filteredItemTypes[index];
                return InkWell(
                  onTap: () async {
                    final item = await Get.to(
                        () => ItemEditView(selectedType: itemType));
                    onItemSelected(item);
                  },
                  child: ListTile(
                    leading: Image.asset(itemType.image),
                    title: Text(itemType.name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itemType.description!),
                        SizedBox(height: 8),
                        // Text('Type: ${itemTypes[index].type}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
