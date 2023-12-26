import 'package:flutter/material.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/avatar.dart';
import 'package:vagali/widgets/gradient_text.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;
  final List<Widget> actions;

  UserAppBar({
    super.key,
    required this.user,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      // hides leading widget
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(0),
                child: Avatar(image: user.image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientText(
                      'Bom dia, ${user.firstName}',
                      style: ThemeTypography.semiBold16,
                    ),
                    Text(
                      'Você tem uma nova reserva',
                      style: ThemeTypography.regular12
                          .apply(color: ThemeColors.grey4),
                    ),
                  ],
                ),
              ),
              Row(children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: ThemeColors.grey4,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: ThemeColors.grey4,
                  ),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
