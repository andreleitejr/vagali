import 'package:flutter/material.dart';
import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/selection_chip.dart';

class ChipSelector<T extends SelectableItem> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;

  // final Function(List<T>) onSelectionChanged;
  final bool isSingleSelection;
  final String? error;

  const ChipSelector(
      {Key? key,
      required this.items,
      required this.selectedItems,
      // required this.onSelectionChanged,
      this.isSingleSelection = false,
      this.error})
      : super(key: key);

  @override
  _ChipSelectorState<T> createState() => _ChipSelectorState<T>();
}

class _ChipSelectorState<T extends SelectableItem>
    extends State<ChipSelector<T>> {
  void toggleSelection(T item) {
    if (widget.isSingleSelection) {
      widget.selectedItems.add(item);
    } else {
      if (widget.selectedItems.contains(item)) {
        widget.selectedItems.remove(item);
      } else {
        widget.selectedItems.add(item);
      }
    }
    // widget.onSelectionChanged(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    print(
        'HUASDHUHSUHUADSHUADSHADSUH SELECTED ITEMS dd3 ${widget.selectedItems.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: widget.items.map((item) {
            return InkWell(
              onTap: () {
                toggleSelection(item);
              },
              child: SelectionChip(
                label: item.title,
                isSelected: widget.selectedItems.any(
                  (element) => element.title == item.title,
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Text(
            widget.error!,
            style: const TextStyle(color: ThemeColors.red),
          ),
      ],
    );
  }
}
