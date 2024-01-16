import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/utils/extensions.dart';

import 'input.dart';

enum DateInputType { birthday, reservation }

Future<DateTime?> selectDateTime(
    BuildContext context, DateInputType dateInputType,
    {bool showTime = false, DateTime? initialDate}) async {
  final DateTime currentDate = DateTime.now();
  DateTime? pickedDateTime;

  if (dateInputType == DateInputType.birthday) {
    pickedDateTime = await showDatePicker(
      helpText: 'Selecione a data de aniversário',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      context: context,
      initialDate:
          DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
      firstDate: DateTime(1900, 1, 1),
      lastDate:
          DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
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
  } else if (dateInputType == DateInputType.reservation && showTime) {
    pickedDateTime = await showDatePicker(
      helpText: 'Selecione a data',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      context: context,
      initialDate: initialDate ?? currentDate,
      firstDate: initialDate ?? currentDate,
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
  }

  if (pickedDateTime != null && showTime) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
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
      pickedDateTime = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }

  return pickedDateTime;
}

class DateInput extends StatelessWidget {
  final DateTime? date;
  final String hintText;
  final Function(DateTime) onDateSelected;
  final String? error;
  final DateInputType dateInputType;
  final bool showTime;
  final DateTime? initialDate;
  final bool enabled;
  final bool openDatePicker;

  DateInput({
    super.key,
    this.date,
    // required this.controller,
    required this.hintText,
    required this.onDateSelected,
    this.error,
    required this.dateInputType,
    this.showTime = false,
    this.initialDate,
    this.enabled = true,
    this.openDatePicker = true,
  });


  @override
  Widget build(BuildContext context) {

    return Input(
      initialValue: date?.toMonthlyAndYearFormattedString(),
      enabled: enabled,
      onChanged: (v) {},
      keyboardType: TextInputType.datetime,
      hintText: hintText,
      onTap: () async {
        final date = await selectDateTime(
          context,
          dateInputType,
          showTime: showTime,
          initialDate: initialDate,
        );

        if (date != null) onDateSelected(date);

        FocusScope.of(context).requestFocus(FocusNode());
      },
      error: error != null && error!.isNotEmpty ? error : null,
      // onChanged: (String) {},
    );
  }
}
