import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vagali/features/calendar/controllers/calendar_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/widgets/reservation_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/empty_list.dart';
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
              leftChevronMargin: EdgeInsets.zero,
              rightChevronMargin: EdgeInsets.zero,
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
              tablePadding: EdgeInsets.symmetric(horizontal: 12),
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
                  style: ThemeTypography.semiBold16,
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
                      style: ThemeTypography.semiBold12.apply(
                        color: ThemeColors.primary,
                      ),
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ThemeColors.grey1,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: ThemeTypography.regular12.apply(
                      color: ThemeColors.grey3,
                    ),
                  ),
                );
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
          const SizedBox(height: 16),
          if (controller.selectedReservations.isNotEmpty) ...[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    controller.activitiesTitle.value,
                    style: ThemeTypography.medium14,
                  ),
                ),
              ],
            ),
          ],
          if (controller.selectedReservations.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: controller.selectedReservations.length,
                itemBuilder: (BuildContext context, int index) {
                  final reservation = controller.selectedReservations[index];

                  return ReservationItem(reservation: reservation);
                },
              ),
            ),
        ],
      ),
    );
  }
}
