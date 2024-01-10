import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
import 'package:vagali/features/home/landlord/widgets/confirmation_widget.dart';
import 'package:vagali/features/home/landlord/widgets/tracking_location.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/widgets/reservation_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/shimmer_box.dart';
import 'package:vagali/widgets/title_with_action.dart';
import 'package:vagali/widgets/title_with_icon.dart';
import 'package:vagali/widgets/user_app_bar.dart';

class LandlordHomeView extends StatelessWidget {
  final _controller = Get.put(LandlordHomeController());

  LandlordHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(
        user: _controller.landlord,
      ),
      body: Obx(
        () {
          if (_controller.loading.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Carregando reservas',
                  style: ThemeTypography.semiBold14
                      .apply(color: ThemeColors.primary),
                ),
                const SizedBox(height: 16),
                Loader(),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (_controller.hasOpenReservation) {
                  return ConfirmationWidget(
                    reservation: _controller.currentReservation.value!,
                    onReservationUpdate: () =>
                        _controller.verifyStatusAndUpdateReservation(),
                  );
                }
                return Container();
              }),
              const SizedBox(height: 16),
              TitleWithAction(
                title: 'Próximas reservas',
                icon: Coolicons.calendar,
                actionText: 'Ver tudo',
                onActionPressed: () {},
              ),
              ListView.builder(
                itemCount: _controller.scheduledReservations.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final reservation = _controller.scheduledReservations[index];

                  return ReservationItem(reservation: reservation);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
