import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorMessage extends StatelessWidget {
  final RxString error;
  final RxBool showErrors;

  const ErrorMessage({
    super.key,
    required this.error,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (showErrors.isTrue && error.isNotEmpty) {
        return Text(
          error.value,
          style: const TextStyle(color: Colors.red),
        );
      }
      return const SizedBox();
    });
  }
}
