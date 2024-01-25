import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/home/views/base_view.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/views/item_edit_view.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/search_input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ItemTypeListView extends StatelessWidget {
  final Function(ItemType) onItemSelected;

  const ItemTypeListView({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                onTap: () => onItemSelected(itemTypes[index]),
                child: ListTile(
                  leading: Coolicon(icon: itemTypes[index].icon),
                  title: Text(itemTypes[index].name!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(itemTypes[index].description!),
                      SizedBox(height: 8),
                      Text('Type: ${itemTypes[index].type}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
