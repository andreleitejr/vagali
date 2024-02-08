import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/features/item/repositories/item_repository.dart';
import 'package:vagali/features/payment/models/payment_method.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/price_service.dart';
import 'package:vagali/theme/images.dart';

class ReservationEditController extends GetxController {
  ReservationEditController({required this.parking});

  final Parking parking;

  final tenant = Get.find<User>();

  final _reservationRepository = Get.put(ReservationRepository());
  final _itemRepository = Get.put(ItemRepository());

  final reservation = Rx<Reservation?>(null);

  final tenantItems = <Item>[].obs;
  final tenantVehicles = <Vehicle>[].obs;
  final showTenantItemsList = false.obs;
  final showItemTypeList = false.obs;

  final nameController = ''.obs;
  final reservationMessageController = ''.obs;

  final reservationError = ''.obs;

  final isConfirmed = false.obs;

  final item = Rx<Item?>(null);
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final paymentMethod = Rx<PaymentMethodItem?>(null);

  final totalCost = Rx<double>(0.0);

  bool get isItemValid => item.value != null;

  bool get isDateValid => startDate.value != null && endDate.value != null;

  bool get isPaymentMethodValid => paymentMethod.value != null;

  final showErrors = RxBool(false);

  @override
  Future<void> onInit() async {
    await _fetchTenants();
    await _fetchVehicles();

    if (tenantItems.isNotEmpty) {
      tenantItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      tenantItems.sort((b, a) => a.type.compareTo(b.type));
      item.value = tenantItems.firstWhere((i) => i.type == ItemType.vehicle);
    }
    everAll([startDate, endDate], (_) {
      _updateTotalCost();
    });

    super.onInit();
  }

  Future<void> _fetchTenants() async {
    final items = await _itemRepository.getAll(userId: tenant.id!);
    tenantItems.assignAll(items.where((i) => i.type != ItemType.vehicle));

    print(
        'HSDUHDSUDSHSUAHDSU HEHEHEHEHEHEHE ${tenantItems.any((element) => element is Vehicle)}');
    print('Successfull fetch ${tenantItems.length} tenant itens.');
  }

  Future<void> _fetchVehicles() async {
    final vehicles = await _itemRepository.getVehicles(userId: tenant.id!);

    tenantVehicles.assignAll(vehicles);
    tenantItems.addAll(tenantVehicles);
    tenantItems.toSet().toList();
    print(
        'HSDUHDSUDSHSUAHDSU HEHEHEHEHEHEHE ${tenantItems.any((element) => element is Vehicle)}');
    print('Successfull fetch ${tenantItems.length} tenant vehicleeeeeeeees.');
  }

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

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  bool isValid() => isItemValid && isDateValid && isPaymentMethodValid;

  Future<SaveResult?> createReservation() async {
    if (!isValid()) {
      return null;
    }

    final reservationMessage = reservationMessageController.value;

    final total = totalCost.value;

    reservation.value = Reservation(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      parkingId: parking.id!,
      tenantId: tenant.id!,
      startDate: startDate.value!,
      endDate: endDate.value!,
      totalCost: total,
      landlordId: parking.userId,
      reservationMessage: reservationMessage,
      itemId: item.value!.id!,
      locationHistory: [
        LocationHistory(
          latitude: 0,
          longitude: 0,
          heading: 0,
          timestamp: DateTime.now(),
        ),
      ],
      status: ReservationStatus.pendingPayment,
      paymentMethod: paymentMethod.value!.title,
    );

    final reservationId =
        await _reservationRepository.saveAndGetId(reservation.value!);

    if (reservationId != null) {
      reservation.value!.id = reservationId;
      Get.put<Reservation>(reservation.value!, tag: 'currentReservation');
      return SaveResult.success;
    }
    return SaveResult.failed;
  }
}
