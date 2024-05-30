import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';


class WarningDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirm;

  WarningDialog({
    required this.title,
    required this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      title: Text(
        title,
        style: ThemeTypography.semiBold14.apply(
          color: ThemeColors.primary,
        ),
      ),
      content: Text(
        description,
        style: ThemeTypography.regular14.apply(
          color: ThemeColors.grey4,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancelar',
            style: ThemeTypography.regular14.apply(
              color: ThemeColors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Get.back();
          },
          child: Text(
            'Confirmar',
            style: ThemeTypography.semiBold14.apply(
              color: ThemeColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showWarningDialog(
  BuildContext context, {
  required String title,
  required String description,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return WarningDialog(
        title: title,
        description: description,
        onConfirm: onConfirm,
      );
    },
  );
}
