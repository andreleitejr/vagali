import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';

final today = DateUtils.dateOnly(DateTime.now());

class CalendarController extends GetxController {
  CalendarController(this.reservations);

  // final ReservationRepository _reservationRepository = Get.find();

  final List<Reservation> reservations;

  final reservationDates = <DateTime>[].obs;

  final selectedReservations = <Reservation>[].obs;

  final selectedDates = <DateTime>[].obs;

  final activitiesTitle = ''.obs;

  void getReservationsWithinSelectedDate(DateTime date) {
    activitiesTitle.value = 'Reservas para o dia ${date.day}';
    selectedReservations.clear();

    for (var reservation in reservations) {
      DateTime start = reservation.startDate;

      if (start.day == date.day) {
        selectedReservations.add(reservation);
      }
    }
    selectedReservations.sort((a, b) => a.startDate.compareTo(b.startDate));
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
    selectedDates.value = getAllReservationDates();
    getReservationsWithinSelectedDate(DateTime.now());
    // multiDatePickerValueWithDefaultValue.addAll(getAllReservationDates());
    super.onInit();
  }
}
