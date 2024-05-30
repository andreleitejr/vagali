import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/custom_icon.dart';
import 'package:vagali/widgets/snackbar.dart';

class CopyButton extends StatelessWidget {
  final String title;
  final String description;
  final String? snackBarMessage;
  final String? infoToCopy;

  const CopyButton({
    super.key,
    required this.title,
    required this.description,
    this.snackBarMessage,
    this.infoToCopy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final informationToCopy = infoToCopy ?? description;
        Clipboard.setData(ClipboardData(text: informationToCopy));
        Get.snackbar(
          '',
          '',
          titleText: Text(
            snackBarMessage ?? 'Copiado com sucesso',
            style: ThemeTypography.regular14,
          ),
          messageText: Container(),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ThemeTypography.semiBold14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: ThemeTypography.regular14.apply(
                      // color: widget.hasError ? Colors.red : ThemeColors.grey4,
                      color: ThemeColors.grey4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            CustomIcon(
              icon: ThemeIcons.files,
              color: ThemeColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
