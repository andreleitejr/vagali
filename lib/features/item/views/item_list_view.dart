import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/home/views/base_view.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/views/item_edit_view.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/search_input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ItemTypeListView extends StatelessWidget {
  const ItemTypeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopNavigationBar(title: 'O que gostaria de guardar?'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchInput(
              searchText: '',
              hintText: 'Buscar objetos',
              onSearch: (_) {},
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: itemTypes.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Get.to(
                        () => ItemEditView(selectedType: itemTypes[index]),
                  ),
                  child: ListTile(
                    leading: Image.asset(itemTypes[index].image),
                    title: Text(itemTypes[index].name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itemTypes[index].description!),
                        SizedBox(height: 8),
                        // Text('Type: ${itemTypes[index].type}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
