import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vagali/features/calendar/controllers/calendar_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/widgets/reservation_history_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/date_card.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class CalendarView extends StatefulWidget {
  final List<Reservation> reservations;

  const CalendarView({super.key, required this.reservations});

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late CalendarController controller;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CalendarController(widget.reservations));
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Calendário de Reservas',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: {
              CalendarFormat.month: 'Mensal',
              CalendarFormat.week: 'Semanal'
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              controller.getReservationsWithinSelectedDate(selectedDay);
            },
            headerStyle: HeaderStyle(
              leftChevronIcon: Coolicon(
                icon: Coolicons.chevronLeft,
              ),
              rightChevronIcon: Coolicon(
                icon: Coolicons.chevronRight,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: ThemeTypography.medium14.apply(
                color: ThemeColors.primary,
              ),
              weekendStyle: ThemeTypography.medium14.apply(
                color: ThemeColors.primary,
              ),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: ThemeTypography.regular12,
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeColors.secondary,
              ),
              todayTextStyle: ThemeTypography.semiBold12.apply(
                color: Colors.white,
              ),
              weekendTextStyle: ThemeTypography.regular12,
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return Text(
                  day.monthName,
                  style: ThemeTypography.semiBold22,
                );
              },
              defaultBuilder: (context, date, events) {
                final dateExists = controller.selectedDates.any(
                  (d) => d.day == date.day && d.month == date.month,
                );

                if (dateExists) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      date.day.toString(),
                      style: ThemeTypography.semiBold12
                          .apply(color: ThemeColors.primary),
                    ),
                  );
                }
              },
              selectedBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ThemeColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: ThemeTypography.semiBold14
                        .apply(color: ThemeColors.lightGreen),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.selectedReservations.length,
              itemBuilder: (BuildContext context, int index) {
                final reservation = controller.selectedReservations[index];

                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HourCard(date: reservation.startDate),
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
                      Text(
                        '+${reservation.totalCost.toMonetaryString()}',
                        style: ThemeTypography.medium14.apply(
                          color: ThemeColors.primary,
                        ),
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
          ),
        ],
      ),
    );
  }
}
