import 'package:flutter/material.dart';
import 'package:vagali/apps/tenant/features/home/views/base_view.dart';
import 'package:vagali/features/item/controllers/item_list_controller.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/search_input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ItemListView extends StatelessWidget {
  final controller = ItemListController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopNavigationBar(
        title: 'O que gostaria de guardar?',
      ),
      body: Column(
        children: [
          SearchInput(
            searchText: '',
            hintText: 'Buscar objetos',
            onSearch: (_) {},
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: itemTypes.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _navigateToItemTypePage(context, itemTypes[index]),
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
      ),
    );
  }

  void _navigateToItemTypePage(BuildContext context, ItemType itemType) {
    Map<String, Widget> itemTypePages = {
      'vehicle': BaseView(),
      'stock': BaseView(),
    };

    Widget? targetPage = itemTypePages[itemType.type];

    if (targetPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => targetPage,
        ),
      );
    }
  }
}
