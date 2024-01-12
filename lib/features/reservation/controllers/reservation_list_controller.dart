import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/services/location_service.dart';

class ReservationListController extends GetxController {
  final tenant = Get.find<User>();
  final _parkingRepository = Get.find<ParkingRepository>();
  final locationService = Get.find<LocationService>();

  final _reservationRepository = Get.put(ReservationRepository());
  final _landlordRepository = Get.put(LandlordRepository());
  final _vehicleRepository = Get.put(VehicleRepository());

  // final currentReservation = Rx<Reservation?>(null);
  final allReservations = <Reservation>[].obs;
  final reservationsInProgress = <Reservation>[].obs;
  final reservationsDone = <Reservation>[].obs;
  final landlords = <Landlord>[].obs;
  final vehicles = <Vehicle>[].obs;
  final parkings = <Parking>[].obs;

  var loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeData();
  }

  Future<void> _initializeData() async {
    loading(true);

    await fetchLandlords();
    await fetchParkings();
    await fetchVehicles();

    _listenToReservationsStream();

    loading(false);
  }

  void _listenToReservationsStream() {
    _reservationRepository.streamAll().listen((dataList) {
      _processReservationData(dataList);
    });
  }

  void _processReservationData(List<Reservation> reservations) {
    for (final reservation in reservations) {
      reservation.landlord = landlords.firstWhereOrNull(
          (landlord) => landlord.id! == reservation.landlordId);
      reservation.vehicle = vehicles
          .firstWhereOrNull((vehicle) => vehicle.id == reservation.vehicleId);
      print(' HUASDHUSDHDSUAHSDAUHDUHDUHSDAH ${parkings.length}');
      reservation.parking = parkings
          .firstWhereOrNull((parking) => parking.id! == reservation.parkingId);

      if (reservation.landlord != null &&
          reservation.vehicle != null &&
          reservation.parking != null) {
        allReservations.add(reservation);
      }
    }

    final inProgress =
        allReservations.where((reservation) => reservation.isInProgress);

    reservationsInProgress.assignAll(inProgress);

    final done = allReservations.where((reservation) => reservation.isDone);
    reservationsDone.assignAll(done);

    reservationsInProgress.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    for (final res in reservationsInProgress) {
      if (res.parking == null)
        print('asdhusdahuhsaduhdsauhuah parking id ${res.parkingId}');
    }
    // currentReservation.value =
    //     reservationsInProgress.firstWhereOrNull((r) => !r.isConcluded || !r.isCanceled);
    //
    // if (currentReservation.value != null) {
    //   checkPaymentTimeout();
    //   currentReservation.value!.landlord = landlords.firstWhereOrNull(
    //       (l) => l.id! == currentReservation.value!.landlordId);
    //
    //   currentReservation.value?.vehicle = vehicles.firstWhereOrNull(
    //       (vehicle) => vehicle.id == currentReservation.value?.vehicleId);
    // }

    // reservations.value = reservations
    //     .where((reservation) =>
    //         reservation.isConcluded ||
    //         reservation.isCanceled ||
    //         reservation.isPaymentDenied)
    //     .toList();
  }

  Future<void> fetchLandlords() async {
    try {
      final landlordList = await _landlordRepository.getAll();
      landlords.assignAll(landlordList);
    } catch (error) {
      debugPrint('Error fetching landlords: $error');
    }
  }

  Future<void> fetchParkings() async {
    try {
      final parkingList = await _parkingRepository.getGroup();
      parkings.assignAll(parkingList);
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  Future<void> fetchVehicles() async {
    try {
      final vehicles =
          await _vehicleRepository.getVehiclesFromTenant(tenant.id!);

      if (vehicles != null) {
        this.vehicles.addAll(vehicles);
        Get.put<List<Vehicle>>(vehicles, tag: 'vehicles');
        debugPrint('Successful got vehicles for Tenant.');
      }
    } catch (error) {
      debugPrint('Error fetching nearby parkings: $error');
    }
  }

  Future<void> verifyStatusAndUpdateReservation(Reservation reservation) async {
    if (reservation.isConfirmed) {
      await confirmReservationStarted(reservation);
    } else if (reservation.isParked) {
      await confirmReservationConclusion(reservation);
    }
  }

  Future<void> confirmReservationStarted(Reservation reservation) async {
    try {
      await _reservationRepository.updateReservationStatus(
        reservation.id!,
        ReservationStatus.userOnTheWay,
      );

      checkAndStartLocationTracking(reservation);
    } catch (error) {
      debugPrint('Erro ao confirmar a reserva: $error');
    }
  }

  Future<void> confirmReservationConclusion(Reservation reservation) async {
    try {
      await _reservationRepository.updateReservationStatus(
        reservation.id!,
        ReservationStatus.concluded,
      );
    } catch (error) {
      debugPrint('Erro ao confirmar a reserva: $error');
    }
  }

  void checkAndStartLocationTracking(Reservation reservation) {
    final currentTime = DateTime.now();
    final timeDifference = reservation.startDate.difference(currentTime);

    if (timeDifference <= const Duration(hours: 1)) {
      locationService.startLocationTracking(reservation);
    }
  }

  void checkPaymentTimeout(Reservation reservation) {
    final currentTime = DateTime.now();

    if (reservation.isPendingPayment) {
      final reservationTime = reservation.createdAt;
      final timeDifference = currentTime.difference(reservationTime);

      if (timeDifference >= const Duration(minutes: 10)) {
        _cancelReservationDueToTimeout(reservation);
      }
    }
  }

  Future<void> _cancelReservationDueToTimeout(Reservation reservation) async {
    try {
      await _reservationRepository.updateReservationStatus(
        reservation.id!,
        ReservationStatus.paymentTimeOut,
      );

      debugPrint('Reserva cancelada devido ao tempo limite de pagamento.');
    } catch (error) {
      debugPrint('Erro ao cancelar a reserva devido ao tempo limite: $error');
    }
  }
}
