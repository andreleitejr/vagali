import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/landlord/controllers/dashboard_controller.dart';
import 'package:vagali/features/home/landlord/widgets/confirmation_widget.dart';
import 'package:vagali/features/home/landlord/widgets/tracking_location.dart';

import 'package:vagali/widgets/loader.dart';
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
      body: Obx(() {
        if (_controller.loading.isTrue) {
          return const Loader();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Obx(() {
              if (_controller.hasOpenReservation) {

                return ConfirmationWidget(
                  controller: _controller,
                );
              }
              return Container();
            }),
            const SizedBox(height: 16),

          ],
        );
      }),
    );
  }
}
