import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/avatar.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/gradient_text.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final User user;
  // final List<Widget> actions;

  final LandlordHomeController controller;

  UserAppBar({
    super.key,
    required this.controller,
    // required this.user,
    // this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final user = controller.landlord;
    return AppBar(
      backgroundColor: Colors.transparent,
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
                    Text(
                      '${controller.getGreeting()}, ${user.firstName}',
                      style: ThemeTypography.semiBold14.apply(
                        color: ThemeColors.primary,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.scheduledReservations.isNotEmpty
                            ? 'Você tem ${controller.scheduledReservations.length} reservas agendadas'
                            : 'Você não tem nenhuma reserva agendada',
                        style: ThemeTypography.regular12.apply(
                          color: ThemeColors.grey4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Row(children: [
              //   // IconButton(
              //   //   onPressed: () {},
              //   //   icon: const Icon(
              //   //     Icons.search,
              //   //     color: ThemeColors.grey4,
              //   //   ),
              //   // ),
              //   Coolicon(
              //     onTap: () {},
              //     padding: const EdgeInsets.only(right: 16),
              //     icon: Coolicons.bell,
              //   ),
              // ]),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
