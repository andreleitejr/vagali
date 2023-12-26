import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  SelectionChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Chip(
        padding: const EdgeInsets.all(16),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
        backgroundColor: isSelected ? ThemeColors.intermediary : ThemeColors.grey2,
      ),
    );
  }
}
