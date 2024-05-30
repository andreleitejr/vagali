import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/controllers/dashboard_controller.dart';
import 'package:vagali/features/home/widgets/confirmation_widget.dart';
import 'package:vagali/features/reservation/widgets/reservation_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/empty_list.dart';
import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/title_with_action.dart';
import 'package:vagali/widgets/user_app_bar.dart';

class LandlordHomeView extends StatelessWidget {
  final LandlordHomeController controller;

  LandlordHomeView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(
        controller: controller,
      ),
      body: Obx(
        () {
          if (controller.loading.value) {
            return Loader();
          }

          if (controller.scheduledReservations.isEmpty &&
              controller.allReservations.isEmpty) {
            return Center(child: EmptyList());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Obx(() {
                  if (controller.hasOpenReservation) {
                    return Column(
                      children: [
                        ConfirmationWidget(
                          controller: controller,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return Container();
                }),
                if (controller.allReservations.isNotEmpty)
                  TitleWithAction(
                    title: 'Meu histórico de reservas',
                    icon: ThemeIcons.calendar,
                    actionText: '',
                    onActionPressed: () {},
                  ),
                ListView.builder(
                  itemCount: controller.allReservations.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final reservation = controller.allReservations[index];
                    return ReservationItem(reservation: reservation);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
