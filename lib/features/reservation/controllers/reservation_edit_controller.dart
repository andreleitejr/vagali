import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/vehicle/controllers/vehicle_edit_controller.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/price_service.dart';
import 'package:vagali/theme/images.dart';

class ReservationEditController extends GetxController {
  final Tenant tenant = Get.find();
  final vehicles = Get.find<List<Vehicle>>(tag: 'vehicles');

  final _repository = Get.put(ReservationRepository());
  final vehicleEditController = Get.put(VehicleEditController());
  final reservation = Rx<Reservation?>(null);

  final Parking parking;

  bool userHasVehicle() => vehicles.isNotEmpty;

  ReservationEditController({required this.parking});

  final nameController = TextEditingController();
  final TextEditingController reservationMessageController =
      TextEditingController();

  final RxString reservationError = RxString('');

  final RxBool isConfirmed = false.obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  bool get isDateValid => startDate.value != null && endDate.value != null;

  void onDatesSelected(DateTime? start, DateTime? end) {
    startDate.value = start;
    if (endDate.value != null && endDate.value!.isBefore(startDate.value!)) {
      endDate.value = null;
    } else {
      endDate.value = end;
    }

    if (isDateValid) {
      totalCost.value = PriceService.calculatePrice(
        startDate.value!,
        endDate.value!,
      );
    }
  }

  final Rx<double> totalCost = Rx<double>(0.0);
  String? vehicleId;

  @override
  Future<void> onInit() async {
    await _loadParkingMarker();
    everAll([startDate, endDate], (_) {
      _updateTotalCost();
    });
    super.onInit();
  }

  void _updateTotalCost() {
    final start = startDate.value;
    final end = endDate.value;

    if (start != null && end != null) {
      if (end.isAfter(start) && end.difference(start).inHours >= 1) {
        final pricePerHour = parking.price.hour!;
        final durationInHours = end.difference(start).inHours;
        final totalCostValue = pricePerHour * durationInHours.toDouble();
        totalCost.value = totalCostValue;
        reservationError.value = '';
      } else {
        reservationError.value = 'É preciso agendar pelo menos 1 hora.';
      }
    }
  }

  final showErrors = RxBool(false);

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  // bool validateStartTime() {
  //   if (startTime.value == null) {
  //     reservationError.value = 'Selecione uma hora de início';
  //     return false;
  //   }
  //
  //   final dayOfWeek = DateFormat('EEEE').format(startTime.value!);
  //   final operatingHours = parking.operatingHours.daysAndHours[dayOfWeek];
  //
  //   if (operatingHours != null) {
  //     final startTimeString = DateFormat('HH:mm').format(startTime.value!);
  //     final openTime = operatingHours['abertura'];
  //     final closeTime = operatingHours['fechamento'];
  //
  //     if (startTimeString.compareTo(openTime!) < 0 ||
  //         startTimeString.compareTo(closeTime!) >= 0) {
  //       reservationError.value = 'Fora do horário de funcionamento';
  //       return false;
  //     }
  //   } else {
  //     reservationError.value = 'O estacionamento não opera neste dia';
  //     return false;
  //   }
  //
  //   reservationError.value = '';
  //   return true;
  // }

  // bool validateEndTime() {
  //   if (endTime.value == null) {
  //     reservationError.value = 'Selecione uma hora de término';
  //     return false;
  //   }
  //
  //   final dayOfWeek = DateFormat('EEEE').format(endTime.value!);
  //   final operatingHours = parking.operatingHours.daysAndHours[dayOfWeek];
  //
  //   if (operatingHours != null) {
  //     // A data de término está dentro das horas de operação para o dia
  //     final endTimeString = DateFormat('HH:mm').format(endTime.value!);
  //     final openTime = operatingHours['abertura'];
  //     final closeTime = operatingHours['fechamento'];
  //
  //     if (endTimeString.compareTo(openTime!) < 0 ||
  //         endTimeString.compareTo(closeTime!) > 0) {
  //       reservationError.value = 'Fora do horário de funcionamento';
  //       return false;
  //     }
  //   } else {
  //     reservationError.value = 'O estacionamento não opera neste dia';
  //     return false;
  //   }
  //
  //   reservationError.value = '';
  //   return true;
  // }

  bool isVehicleValid() {
    if (!userHasVehicle()) {
      reservationError.value = 'Insira os dados do veiculo';

      return false;
    } else {
      vehicleId = tenant.vehicles.first.id;
    }
    if (vehicleId == null || vehicleId!.isEmpty) {
      reservationError.value = 'Selecione um veículo válido';
      return false;
    }
    return true;
  }

  bool isValid() {
    // final isStartTimeValid = validateStartTime();
    // final isEndTimeValid = validateEndTime();
    // final isVehicleIdValid =
    //     isVehicleValid(); // Adicionando verificação de veículo

    return isDateValid;
  }

  Future<SaveResult?> createReservation() async {
    if (!isValid()) {
      return null;
    }

    final reservationMessage = reservationMessageController.text;

    final total = totalCost.value;

    if (!userHasVehicle()) {
      vehicleId = await vehicleEditController.createVehicleAndGetId();

      if (vehicleId == null) {
        print('Erro ao criar o veículo');
        return SaveResult.failed;
      }
    }

    // _tenantRepository.getTenantVehicles();
    vehicleId = vehicles.first.id;

    reservation.value = Reservation(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parkingId: parking.id!,
      tenantId: tenant.id!,
      startDate: startDate.value!,
      endDate: endDate.value!,
      totalCost: total,
      landlordId: parking.ownerId,
      reservationMessage: reservationMessage,
      vehicleId: vehicleId!,
      locationHistory: [
        LocationHistory(
          latitude: 0,
          longitude: 0,
          heading: 0,
          timestamp: DateTime.now(),
        ),
      ],
      status: ReservationStatus.pendingPayment,
    );

    final reservationId = await _repository.saveAndGetId(reservation.value!);

    if (reservationId != null) {
      reservation.value!.id = reservationId;
      Get.put<Reservation>(reservation.value!, tag: 'currentReservation');
      return SaveResult.success;
    }
    return SaveResult.failed;
  }

  Future<void> updatePaymentReservationStatus(ReservationStatus status) async {
    try {
      if (reservation.value == null) return;
      await _repository.updateReservationStatus(reservation.value!.id!, status);
    } catch (error) {
      print('Erro ao atualizar o status da reserva: $error');
      rethrow;
    }
  }

  final parkingMarkerIcon = Rx<BitmapDescriptor?>(null);

  Future<void> loadMapStyle(GoogleMapController controller) async {
    final String styleString =
        await rootBundle.loadString('assets/map_style.json');

    controller.setMapStyle(styleString);
  }

  Future<void> _loadParkingMarker() async {
    final Uint8List markerIconData =
        await getBytesFromAsset(Images.marker, 128);
    parkingMarkerIcon.value = BitmapDescriptor.fromBytes(markerIconData);
    print(
        ' JISJISDAJISDAJDSHDSAUHDASUDSHAUDSAHUHDSAIJASISJOSDAJSDA ${parkingMarkerIcon}');
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final frameInfo = await codec.getNextFrame();
    final byteData =
        await frameInfo.image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
