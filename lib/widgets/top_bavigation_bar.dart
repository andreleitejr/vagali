import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool showLeading;

  TopNavigationBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showLeading
          ? IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back,
                color: ThemeColors.grey4,
              ),
            )
          : null,
      title: Text(
        title,
        style: ThemeTypography.medium16.apply(
          color: ThemeColors.grey4,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
