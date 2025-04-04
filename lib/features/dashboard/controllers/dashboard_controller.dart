import 'package:get/get.dart';
import 'package:vagali/features/cashout/controllers/cashout_edit_controller.dart';
import 'package:vagali/features/cashout/models/cashout.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class DashboardController extends GetxController {
  DashboardController(this.reservations);

  final _cashOutController = Get.put(CashOutController());

  final List<Reservation> reservations;

  final concludedReservations = <Reservation>[].obs;
  final doneReservations = <Reservation>[].obs;
  final openReservations = <Reservation>[].obs;
  final cashOuts = <CashOut>[].obs;

  double get balance {
    double totalBalance = 0;

    for (final reservation in concludedReservations) {
      totalBalance += reservation.totalCost;
    }

    if (cashOuts.isNotEmpty) {
      final pendingCashOut = cashOuts.firstWhereOrNull(
          (cashOut) => cashOut.status == CashOutStatus.pending);

      if (pendingCashOut != null) {
        totalBalance -= pendingCashOut.amount;
      }
    }

    return totalBalance;
  }

  double get income {
    double totalBalance = 0;

    for (final reservation in openReservations) {
      totalBalance += reservation.totalCost;
    }

    return totalBalance;
  }

  Duration get totalTime {
    Duration totalTime = Duration.zero;

    for (var reservation in openReservations) {
      Duration reservationTime =
          reservation.endDate.difference(reservation.startDate);
      totalTime += reservationTime;
    }

    return totalTime;
  }

  List<Reservation> getReservationsForCurrentWeek() {
    final now = DateTime.now();

    final startOfWeek =
        DateTime(now.year, now.month, now.day - now.weekday + 1);

    final endOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 7,
    );

    return reservations
        .where(
          (reservation) =>
              reservation.startDate.isAfter(startOfWeek) &&
              reservation.startDate.isBefore(endOfWeek),
        )
        .toList();
  }

  Future<SaveResult> requestCashOut() async {
    return _cashOutController.save(balance);
  }

  @override
  void onInit() {
    doneReservations.value =
        reservations.where((reservation) => reservation.isDone).toList();

    concludedReservations.value =
        reservations.where((reservation) => reservation.isConcluded).toList();

    openReservations.value =
        reservations.where((reservation) => reservation.isOpen).toList();

    cashOuts.value = _cashOutController.cashOuts;

    super.onInit();
  }
}
