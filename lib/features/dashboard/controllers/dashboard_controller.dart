import 'package:get/get.dart';
import 'package:vagali/features/reservation/controllers/reservation_list_controller.dart';

class DashboardController extends GetxController {
  final reservationListController = Get.put(ReservationListController());

  double get balance {
    final doneReservations = reservationListController.reservationsDone;
    double totalBalance = 0;

    for (final reservation in doneReservations) {
      totalBalance += reservation.totalCost;
    }

    return totalBalance;
  }

  double get income {
    final openReservations = reservationListController.reservationsInProgress;
    double totalBalance = 0;

    for (final reservation in openReservations) {
      totalBalance += reservation.totalCost;
    }

    return totalBalance;
  }

  Duration get totalTime {
    final openReservations = reservationListController.reservationsInProgress;

    Duration totalTime = Duration.zero;

    for (var reservation in openReservations) {
      Duration reservationTime =
          reservation.endDate.difference(reservation.startDate);
      totalTime += reservationTime;
    }

    return totalTime;
  }
}
