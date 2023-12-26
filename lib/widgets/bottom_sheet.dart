import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/search_input.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<String> items;
  final String title;
  final Function(String) onItemSelected;

  CustomBottomSheet({
    super.key,
    required this.items,
    required this.title,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return items.length <= 15
        ? _buildSimpleBottomSheet()
        : _buildFullBottomSheet(context);
  }

  Widget _buildSimpleBottomSheet() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: ThemeTypography.medium16.apply(
              color: ThemeColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _buildListItem(item)).toList(),
        ],
      ),
    );
  }

  final searchController = TextEditingController();

  Widget _buildFullBottomSheet(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: ThemeTypography.medium16.apply(
              color: ThemeColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          SearchInput(
            searchText: '',
            onSearch: (String v) {},
            hintText: 'Buscar itens',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              // controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) => _buildListItem(items[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String item) {
    return GestureDetector(
      onTap: () {
        onItemSelected(item);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.75,
          color: ThemeColors.grey2,
        ))),
        child: Text(
          item,
          // textAlign: TextAlign.center,
          style: ThemeTypography.medium14,
        ),
      ),
    );
  }
}
