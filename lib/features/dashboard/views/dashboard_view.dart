import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/features/dashboard/controllers/dashboard_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/widgets/reservation_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
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
            Container(
              height: 200,
              child: ChartWidget(
                  reservations: _controller.getReservationsForCurrentWeek()),
            ),
            TitleWithAction(
              title: 'Meu extrato',
              icon: Coolicons.calendar,
              actionText: 'Ver tudo',
              onActionPressed: () {},
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40,
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta titleMeta) {
                  return Text(
                    'R\$${value}',
                    style: ThemeTypography.regular10.apply(
                      color: ThemeColors.grey4,
                    ),
                  );
                },
              ),
            ),
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
                          style: DateTime.now().weekday == value ? ThemeTypography.semiBold10.apply(
                            color: ThemeColors.grey4,
                          ) : ThemeTypography.regular10.apply(
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
      ),
    );
  }
}
