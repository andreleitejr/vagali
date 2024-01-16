import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingPartialEditWidget extends StatelessWidget {
  final String title;
  final Widget body;
  final bool isValid;
  final VoidCallback onSave;

  ParkingPartialEditWidget({
    super.key,
    required this.title,
    required this.body,
    required this.isValid,
    required this.onSave,
  });

  // final controller  = ParkingEditController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: title,
        actions: [
          TextButton(
            onPressed: onSave,
            child: Text(
              'Avancar',
              style: ThemeTypography.medium14.apply(
                color: isValid
                    ? ThemeColors.primary
                    : ThemeColors.grey3,
              ),
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}
