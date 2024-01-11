import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  SwitchButton({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 50,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Borda circular
          color: value ? ThemeColors.primary : ThemeColors.grey2,
        ),
        child: Row(
          mainAxisAlignment:
              value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma circular
                color: Colors.white, // Cor do círculo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
