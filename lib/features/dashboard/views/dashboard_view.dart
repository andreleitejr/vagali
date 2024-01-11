import 'package:brasil_fields/brasil_fields.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/dashboard/controllers/dashboard_controller.dart';
import 'package:vagali/features/dashboard/widgets/dashboard_card.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/widgets/reservation_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/title_with_action.dart';
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
        // padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Coolicon(
                            icon: Coolicons.creditCard,
                            width: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Saldo total",
                            style: ThemeTypography.regular14
                                .apply(color: ThemeColors.grey4),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              '${UtilBrasilFields.obterReal(_controller.balance)}',
                              style: ThemeTypography.semiBold32,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: ThemeColors.grey1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 4),
                                Coolicon(
                                  icon: Coolicons.download,
                                  color: ThemeColors.primary,
                                  width: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Realizar saque",
                                  style: ThemeTypography.medium14.apply(
                                    color: ThemeColors.primary,
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      DashboardCard(
                        icon: Coolicons.circleCheckOutline,
                        iconColor: Colors.white,
                        title: "A receber",
                        content:
                            '${UtilBrasilFields.obterReal(_controller.income)}',
                        cardColor: ThemeColors.primary,
                        contentColor: ThemeColors.lightGreen,
                      ),
                      SizedBox(width: 16.0),
                      DashboardCard(
                        icon: Coolicons.calendar,
                        iconColor: Colors.white,
                        title: "Reservas futuras",
                        content: "${_controller.totalTime.inHours} horas",
                        cardColor: Colors.blue,
                        contentColor: ThemeColors.lightBlue,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeColors.grey2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ChartWidget(
                      reservations: _controller.getReservationsForCurrentWeek(),
                    ),
                  ),
                ],
              ),
            ),
            TitleWithAction(
              title: 'Meu extrato',
              icon: Coolicons.calendar,
              actionText: 'Ver tudo',
              onActionPressed: () {},
            ),
            ListView.builder(
              itemCount:
                  _controller.reservationListController.reservationsDone.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final reservation = _controller
                    .reservationListController.reservationsDone[index];

                return ReservationItem(reservation: reservation);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  final List<Reservation> reservations;

  ChartWidget({super.key, required this.reservations});

  final daysOfWeek = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  List<Reservation> getReservationsForCurrentWeek() {
    final now = DateTime.now();
    final startOfWeek =
        DateTime(now.year, now.month, now.day - now.weekday + 1);
    final endOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 7);

    return reservations.where((reservation) {
      return reservation.startDate.isAfter(startOfWeek) &&
          reservation.startDate.isBefore(endOfWeek);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        // baselineY: 500,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          // leftTitles: AxisTitles(
          //   sideTitles: SideTitles(
          //     reservedSize: 40,
          //     showTitles: true,
          //     getTitlesWidget: (double value, TitleMeta titleMeta) {
          //       return Text(
          //         'R\$${value}',
          //         style: ThemeTypography.regular10.apply(
          //           color: ThemeColors.grey4,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta titleMeta) {
                if (value >= 0 && value < daysOfWeek.length) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Transform.rotate(
                      angle: -45 * (3.141592653589793 / 180),
                      child: Text(
                        '${daysOfWeek[value.toInt()]}',
                        style: DateTime.now().weekday == value
                            ? ThemeTypography.semiBold10.apply(
                                color: ThemeColors.grey4,
                              )
                            : ThemeTypography.regular10.apply(
                                color: ThemeColors.grey4,
                              ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: List.generate(
          daysOfWeek.length,
          (index) {
            final reservationForDay = reservations.firstWhereOrNull(
              (reservation) => reservation.startDate.weekday == index + 1,
            );
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: ThemeColors.grey2,
                  ),
                  width: 16,
                  toY: reservationForDay?.totalCost ?? 0,
                  color: index.isEven
                      ? ThemeColors.primary
                      : ThemeColors.secondary,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
