import 'package:flutter/material.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';

class ReservationDateWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDatesSelected;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool hasError;

  const ReservationDateWidget({
    Key? key,
    required this.onDatesSelected,
    this.initialStartDate,
    this.initialEndDate,
    this.hasError = false,
  }) : super(key: key);

  @override
  _ReservationWidgetState createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationDateWidget> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
  }

  void _handleStartDateSelected(DateTime date) {
    startDate = date;
    widget.onDatesSelected(startDate, endDate);
  }

  void _handleEndDateSelected(DateTime date) {
    endDate = date;
    widget.onDatesSelected(startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 141,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.5),
        //     spreadRadius: -8,
        //     blurRadius: 20,
        //     offset: const Offset(0, 0),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildDateTimeSelector(
            'Data de entrada:',
            startDate,
            false,
            () {
              _selectDateTime(context);
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          Container(
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            height: 0.75,
            color: ThemeColors.grey3,
          ),
          buildDateTimeSelector(
            'Data de saída:',
            endDate,
            true,
            () {
              _selectDateTime(context, isEndDate: true);
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ],
      ),
    );
  }

  Widget buildDateTimeSelector(
    String title,
    DateTime? date,
    bool isEndDate,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // const SizedBox(width: 16),
            // Container(
            //   height: 32,
            //   width: 32,
            //   padding: const EdgeInsets.all(5),
            //   decoration: BoxDecoration(
            //     color: isEndDate ? ThemeColors.primary : ThemeColors.blue,
            //     borderRadius: BorderRadius.circular(64),
            //   ),
            //   child: const Coolicon(
            //     icon: Coolicons.calendar,
            //     color: Colors.white,
            //   ),
            // ),
            // const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ThemeTypography.semiBold16,
                ),
                const SizedBox(height: 8),
                Text(
                  date?.toFriendlyDateTimeString() ??
                      'Selecione a data de ${isEndDate ? 'saída' : 'entrada'}',
                  style: ThemeTypography.regular14.apply(
                    color: widget.hasError ? Colors.red : ThemeColors.grey4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _dateTimeController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context,
      {bool isEndDate = false}) async {
    final DateTime currentDate = DateTime.now();
    DateTime? pickedDateTime;

    pickedDateTime = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      confirmText: 'Confirmar',
      helpText: 'Selecione a data de início da reserva',
      cancelText: 'Cancelar',
      context: context,
      initialDate: startDate ?? currentDate,
      firstDate: startDate ?? currentDate,
      lastDate: DateTime(currentDate.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ThemeColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      confirmText: 'Confirmar',
      helpText: 'Selecione o horário de início da reserva',
      cancelText: 'Cancelar',
      context: context,
      initialTime: TimeOfDay(hour: currentDate.hour, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ThemeColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final pickedDate = pickedDateTime!;

      pickedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    if (pickedDateTime != null) {
      if (isEndDate) {
        _handleEndDateSelected(pickedDateTime);
      } else {
        _handleStartDateSelected(pickedDateTime);
      }
      _dateTimeController.text = pickedDateTime.toFriendlyDateTimeString();
    }
  }
}
