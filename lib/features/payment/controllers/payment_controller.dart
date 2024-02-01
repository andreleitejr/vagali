import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/payment_service.dart';

class PaymentController extends GetxController {
  PaymentController(this.reservation);

  final _reservationRepository = Get.put(ReservationRepository());

  final Reservation reservation;
  final status = Rx<ReservationStatus?>(null);
  final minutes = 15.obs;
  final seconds = 0.obs;
  final isCountdownFinished = false.obs;

  RxBool get isApproved => (status.value != null &&
          status.value == ReservationStatus.paymentApproved)
      .obs;

  final User tenant = Get.find();

  @override
  void onInit() {
    super.onInit();
    // fetchPaymentMethods();
    _listenToReservationsStream();
    _startCountdown();
  }

  void _listenToReservationsStream() {
    _reservationRepository
        .stream(reservation.id!)
        .listen((databaseReservation) {
      status.value = databaseReservation.status;
    });
  }

  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();

        isCountdownFinished.value = true;
      } else {
        if (seconds.value == 0) {
          minutes.value--;
          seconds.value = 59;
        } else {
          seconds.value--;
        }
      }
    });
  }
}
