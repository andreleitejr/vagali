import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/theme_colors.dart';

class ReservationStatisticsWidget extends StatelessWidget {
  final List<Reservation> reservations;

  ReservationStatisticsWidget({required this.reservations});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text('Minha semana'
                  ''),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(reservations: reservations),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white, // Altere a cor conforme necessário
            ),
            onPressed: () {
              // Lógica de atualização, se necessário
            },
          )
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<Reservation> reservations;

  _LineChart({required this.reservations});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      _getLineChartData(),
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData _getLineChartData() {
    List<FlSpot> chartData = [];

    // Obtém a data de hoje
    DateTime now = DateTime.now();

    // Lógica para extrair os dados de suas reservas e criar o gráfico
    // Utilize totalCost, startDate e endDate para gerar os dados do gráfico

    // Itera por cada dia da última semana
    for (int i = 0; i < 7; i++) {
      // Obtém a data correspondente a este dia da semana na última semana
      DateTime currentDate = now.subtract(Duration(days: now.weekday - i));

      double totalSales = 30;

      // Itera por cada reserva
      for (var reservation in reservations) {
        // Verifica se a reserva ocorreu neste dia da semana
        totalSales += reservation.totalCost;
      }

      chartData.add(FlSpot(1, totalSales));
    }

    return LineChartData(
      backgroundColor: ThemeColors.primary,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: Colors.black,
          barWidth: 8,
          isStrokeCapRound: true,
          // dotData: const FlDotData(show: true),
          // belowBarData: BarAreaData(show: false),
          spots: chartData,
        ),
      ],
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
          left: BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 500,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
          ),
        ),
      ),
      gridData: FlGridData(show: true),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: chartData.isNotEmpty
          ? chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) +
              500
          : 500,
    );
  }

  String _getWeekdayLabel(int weekday) {
    return DateFormat('E')
        .format(DateTime.now().subtract(Duration(days: 7 - weekday)));
  }
}
