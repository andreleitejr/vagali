import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vagali/features/calendar/controllers/calendar_controller.dart';
import 'package:vagali/features/reservation/widgets/reservation_history_item.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/date_card.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;

  final CalendarController controller = Get.put(CalendarController());

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário de Atividades'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            calendarFormat: _calendarFormat,
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
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.red,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(day.toString()),
                );
              },
              defaultBuilder: (context, date, events) {
                final dateExists = controller.selectedDates
                    .any((element) => element.day == date.day);

                if (dateExists) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
              selectedBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
          ),
        ],
      ),
    );
  }
}
