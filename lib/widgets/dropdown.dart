import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

class CustomDropdown<T> extends StatelessWidget {
  final RxBool isDropdownOpen = false.obs;
  final Rx<T> selectedValue;
  final List<T> items;
  final String hintText;
  final Widget Function(T) itemBuilder;
  final void Function(T)? onChanged;

  CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.hintText,
    required this.itemBuilder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: isDropdownOpen.value ? 165 : 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                isDropdownOpen.value = !isDropdownOpen.value;
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeColors.grey1,
                  border: Border.all(color: ThemeColors.grey2),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8),
                    topRight: const Radius.circular(8),
                    bottomLeft: Radius.circular(isDropdownOpen.value ? 0 : 8),
                    bottomRight: Radius.circular(isDropdownOpen.value ? 0 : 8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedValue.value.toString().isEmpty
                            ? hintText
                            : selectedValue.value.toString(),
                        style: selectedValue.value.toString().isEmpty
                            ? ThemeTypography.regular16.apply(
                                color: ThemeColors.grey4,
                              )
                            : ThemeTypography.medium16.apply(
                                color: ThemeColors.intermediary,
                              ),
                      ),
                    ),
                    Icon(
                      isDropdownOpen.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isDropdownOpen.value,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeColors.grey1,
                  border: Border.all(color: ThemeColors.grey2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map((T item) {
                    return GestureDetector(
                      onTap: () {
                        selectedValue.value = item;
                        onChanged?.call(item);
                        isDropdownOpen.value = false;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: itemBuilder(item),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
