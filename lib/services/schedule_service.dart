import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleService extends GetxService {
  final days = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  final selectedDays = <String, bool>{}.obs;
  final openingTimes = <String, TimeOfDay?>{}.obs;
  final closingTimes = <String, TimeOfDay?>{}.obs;
  final isOpenAllDays = false.obs;
  final isTwentyFourSeven = false.obs;
  final selectedOperatingHours = <String, Map<String, String>>{}.obs;

  bool isDaySelected(String day) => selectedDays[day] ?? false;

  void toggleDay(String day, bool value) {
    selectedDays[day] = value;
    selectedDays.refresh();
  }

  TimeOfDay? getOpeningTime(String day) => openingTimes[day];

  TimeOfDay? getClosingTime(String day) => closingTimes[day];

  void setOpeningTime(String day, TimeOfDay? time) {
    final formattedTime = _formatTime(time);
    selectedOperatingHours[day] ??= {};
    selectedOperatingHours[day]!['abertura'] =
        '${formattedTime['hour']}:${formattedTime['minute']}';
    openingTimes[day] = time;
    openingTimes.refresh();
  }

  void setClosingTime(String day, TimeOfDay? time) {
    final formattedTime = _formatTime(time);
    selectedOperatingHours[day] ??= {};
    selectedOperatingHours[day]!['fechamento'] =
        '${formattedTime['hour']}:${formattedTime['minute']}';
    closingTimes[day] = time;
    closingTimes.refresh();
  }

  void toggleOpenAllDays(bool value) {
    isOpenAllDays.value = value;
  }

  void toggleTwentyFourSeven(bool value) {
    isTwentyFourSeven.value = value;
    if (value) {
      // Se o usuário selecionar "Aberto 24 Horas", preencha automaticamente os horários.
      for (final day in days) {
        setOpeningTime(day, TimeOfDay(hour: 0, minute: 0));
        setClosingTime(day, TimeOfDay(hour: 23, minute: 59));
      }
    } else {
      // Caso contrário, limpe os horários.
      openingTimes.clear();
      closingTimes.clear();
    }
  }

  Map<String, String> _formatTime(TimeOfDay? time) {
    if (time != null) {
      return {
        'hour': time.hour.toString().padLeft(2, '0'),
        'minute': time.minute.toString().padLeft(2, '0'),
      };
    }
    return {};
  }

  Map<String, Map<String, String>> getSelectedOperatingHours() {
    final selectedOperatingHours = <String, Map<String, String>>{};
    for (final day in days) {
      if (isDaySelected(day)) {
        final openingTime = getOpeningTime(day);
        final closingTime = getClosingTime(day);
        if (openingTime != null && closingTime != null) {
          selectedOperatingHours[day] = {
            'abertura': '${openingTime.hour}:${openingTime.minute}',
            'fechamento': '${closingTime.hour}:${closingTime.minute}',
          };
        }
      }
    }
    return selectedOperatingHours;
  }
}
