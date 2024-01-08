import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/dashboard/controllers/dashboard_controller.dart';
import 'package:vagali/features/reservation/widgets/reservation_statistics_widget.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/date_card.dart';
import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/shimmer_box.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final _controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Dashboard',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Coolicon(
                      icon: Coolicons.creditCard,
                      scale: 1.2,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Saldo total",
                      style: ThemeTypography.regular14,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        '${_controller.balance}'.toMonetaryString(),
                        style: ThemeTypography.semiBold32,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: ThemeColors.grey2,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.download,
                            color: ThemeColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Realizar saque",
                            style: ThemeTypography.semiBold14.apply(
                              color: ThemeColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),

            // Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: ThemeColors.primary,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Coolicon(
                                icon: Coolicons.circleCheckOutline,
                                scale: 1.2,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "A receber",
                                style: ThemeTypography.semiBold12.apply(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_controller.income}'.toMonetaryString(),
                            style: ThemeTypography.semiBold22.apply(
                              color: ThemeColors.lightGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Coolicon(
                                icon: Coolicons.calendar,
                                scale: 1.2,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "Reservas futuras",
                                style: ThemeTypography.semiBold12.apply(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                _controller.totalTime.inHours.toString(),
                                style: ThemeTypography.semiBold22.apply(
                                  color: ThemeColors.lightBlue,
                                ),
                              ),
                              // SizedBox(width: 4.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    " horas reservadas",
                                    style: ThemeTypography.semiBold12.apply(
                                      color: ThemeColors.lightBlue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meu extrato",
                  style: ThemeTypography.semiBold16,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Ver mais",
                    style: ThemeTypography.medium14.apply(
                      color: ThemeColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            ListView.builder(
              itemCount:
                  _controller.reservationListController.reservationsDone.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final reservation = _controller
                    .reservationListController.reservationsDone[index];

                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DateCard(date: reservation.startDate),
                      ],
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                            "${reservation.tenant?.firstName ?? 'Teste'}"
                            " ${reservation.tenant?.lastName ?? 'Teste'}",
                            style: ThemeTypography.medium14),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "${reservation.startDate.toFriendlyDateTimeString()}"
                    " até ${reservation.endDate.toFriendlyDateTimeString()}",
                    style: ThemeTypography.regular10,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
