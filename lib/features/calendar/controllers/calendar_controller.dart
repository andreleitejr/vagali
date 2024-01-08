import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';

final today = DateUtils.dateOnly(DateTime.now());

class CalendarController extends GetxController {
  final ReservationRepository _reservationRepository = Get.find();

  final reservations = <Reservation>[].obs;

  final reservationDates = <DateTime>[].obs;

  final selectedReservations = <Reservation>[].obs;

  final selectedDates = <DateTime>[].obs;

  void getReservationsWithinSelectedDate(DateTime date) {
    selectedReservations.clear();

    for (var reservation in reservations) {
      DateTime start = reservation.startDate;

      if (start.day == date.day) {
        selectedReservations.add(reservation);
      }
    }
  }

  List<DateTime> getAllReservationDates() {
    List<DateTime> allDates = [];

    for (var reservation in reservations) {
      allDates.add(reservation.startDate);
    }

    return allDates;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    reservations.value = await _reservationRepository.getAll();
    selectedDates.value = getAllReservationDates();
    // multiDatePickerValueWithDefaultValue.addAll(getAllReservationDates());
    super.onInit();
  }
}
