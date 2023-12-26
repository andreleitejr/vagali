import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/widgets/selection_chip.dart';

class ChipSelector<T extends SelectableItem> extends StatefulWidget {
  final List<T> items;
  final String labelText;
  final Function(List<T>) onSelectionChanged;
  final bool isSingleSelection;
  final String? error;

  const ChipSelector(
      {Key? key,
      required this.items,
      required this.labelText,
      required this.onSelectionChanged,
      this.isSingleSelection = false,
      this.error})
      : super(key: key);

  @override
  _ChipSelectorState<T> createState() => _ChipSelectorState<T>();
}

class _ChipSelectorState<T extends SelectableItem>
    extends State<ChipSelector<T>> {
  List<T> selectedItems = [];

  void toggleSelection(T item) {
    setState(() {
      if (widget.isSingleSelection) {
        selectedItems = [item];
      } else {
        if (selectedItems.contains(item)) {
          selectedItems.remove(item);
        } else {
          selectedItems.add(item);
        }
      }
      widget.onSelectionChanged(selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          children: widget.items.map((item) {
            return InkWell(
              onTap: () {
                toggleSelection(item);
              },
              child: SelectionChip(
                label: item.title,
                isSelected: selectedItems.contains(item),
              ),
            );
          }).toList(),
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Text(
            widget.error!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
