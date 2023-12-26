import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/services/schedule_service.dart';

class ScheduleInput extends StatelessWidget {
  final ScheduleService _scheduleService = Get.put(ScheduleService());
  final Function(Map<String, Map<String, String>>) onOperatingHoursChanged;

  ScheduleInput({required this.onOperatingHoursChanged});

  void showOpeningTimePicker(String day) async {
    final selectedTimeOfDay = await showTimePicker(
      context: Get.overlayContext!,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTimeOfDay != null) {
      _scheduleService.setOpeningTime(day, selectedTimeOfDay);

      final newOperatingHours = _scheduleService.getSelectedOperatingHours();
      onOperatingHoursChanged(newOperatingHours);
    }
  }

  void showClosingTimePicker(String day) async {
    final selectedTimeOfDay = await showTimePicker(
      context: Get.overlayContext!,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTimeOfDay != null) {
      _scheduleService.setClosingTime(day, selectedTimeOfDay);

      final newOperatingHours = _scheduleService.getSelectedOperatingHours();
      onOperatingHoursChanged(newOperatingHours);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dias da Semana:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        for (final day in _scheduleService.days)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(day),
                  SizedBox(width: 10),
                  Obx(
                        () => Switch(
                      value: _scheduleService.isDaySelected(day),
                      onChanged: (value) {
                        _scheduleService.toggleDay(day, value);
                        final newOperatingHours =
                        _scheduleService.getSelectedOperatingHours();
                        onOperatingHoursChanged(newOperatingHours);
                      },
                    ),
                  ),
                ],
              ),
              Obx(
                    () {
                  if (_scheduleService.isDaySelected(day)) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Abertura:'),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              child: GestureDetector(
                                onTap: () {
                                  showOpeningTimePicker(day);
                                },
                                child: TextFormField(
                                  controller: TextEditingController(
                                    text: _scheduleService
                                        .getOpeningTime(day)
                                        ?.format(context),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () => showOpeningTimePicker(day),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text('Fechamento:'),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              child: GestureDetector(
                                onTap: () {
                                  showClosingTimePicker(day);
                                },
                                child: TextFormField(
                                  readOnly: true,
                                  initialValue: _formatTime(
                                    _scheduleService.getClosingTime(day),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () => showClosingTimePicker(day),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return Container(); // Oculta os horários quando o dia não estiver selecionado.
                  }
                },
              ),
            ],
          ),
      ],
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time != null) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }
}
