import 'package:flutter/material.dart';
import 'package:vagali/widgets/custom_icon.dart';

class OverImageButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const OverImageButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(48),
        ),
        child: CustomIcon(
          icon: icon,
          color: Colors.black.withOpacity(0.78),
          padding: const EdgeInsets.all(6),
        ),
      ),
    );
  }
}
