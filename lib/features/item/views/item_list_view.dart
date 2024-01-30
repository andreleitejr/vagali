import 'package:flutter/material.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/widgets/item_list_item.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ItemListView extends StatelessWidget {
  final List<Item> items;

  ItemListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Minhas coisas',
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ItemListItem(item: item);
        },
      ),
    );
  }
}
