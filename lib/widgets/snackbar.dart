import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

Future<void> snackBar(
  String title,
  String message, {
  Widget? icon,
}) async {
  Get.snackbar(
    title,
    message,
    backgroundColor: ThemeColors.secondaryGreen,
    colorText: ThemeColors.lightGreen,
    messageText: Text(
      message,
      style: ThemeTypography.regular14.apply(
        color: Colors.white,
      ),
    ),
    icon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: icon,
    ),
  );
}
