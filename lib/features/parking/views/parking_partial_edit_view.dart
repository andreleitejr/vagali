import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingPartialEditWidget extends StatelessWidget {
  final String title;
  final Widget body;
  final RxBool isValid;
  final VoidCallback onSave;

  const ParkingPartialEditWidget({
    super.key,
    required this.title,
    required this.body,
    required this.isValid,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: title,
        actions: [
          Obx(
            () {
              return TextButton(
                onPressed: () {},
                child: Text(
                  'Avancar',
                  style: ThemeTypography.medium14.apply(
                    color: isValid.isTrue
                        ? ThemeColors.primary
                        : ThemeColors.grey3,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
