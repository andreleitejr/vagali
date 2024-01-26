import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/apps/tenant/features/vehicle/models/vehicle.dart';
import 'package:vagali/apps/tenant/models/tenant.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/utils/extensions.dart';

enum ReservationStatus {
  pendingPayment,
  paymentApproved,
  paymentDenied,
  paymentTimeOut,
  canceled,
  confirmed,
  userOnTheWay,
  parked,
  concluded,
  error,
}

class Reservation extends BaseModel {

  final String parkingId;
  final String itemId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalCost;
  final String landlordId;
  final String reservationMessage;
  final List<LocationHistory> locationHistory;
  final ReservationStatus status;

  Landlord? landlord;
  Tenant? tenant;
  Parking? parking;
  Item? item;

  Reservation({
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.parkingId,
    required this.tenantId,
    required this.itemId,
    required this.startDate,
    required this.endDate,
    required this.totalCost,
    required this.landlordId,
    required this.reservationMessage,
    required this.locationHistory,
    required this.status,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'parkingId': parkingId,
      'tenantId': tenantId,
      'itemId': itemId,
      'startTime': startDate.toUtc(),
      'endTime': endDate.toUtc(),
      'totalCost': totalCost,
      'landlordId': landlordId,
      'reservationMessage': reservationMessage,
      'locationHistory':
          locationHistory.map((location) => location.toMap()).toList(),
      'status': status.toStringSimplified(),
      ...super.toMap(),
    };
  }

  Reservation.fromDocument(DocumentSnapshot document)
      : parkingId = document['parkingId'],
        tenantId = document['tenantId'],
        itemId = document['itemId'],
        startDate = (document['startTime'] as Timestamp).toDate(),
        endDate = (document['endTime'] as Timestamp).toDate(),
        totalCost = document['totalCost'],
        landlordId = document['landlordId'],
        reservationMessage = document['reservationMessage'],
        locationHistory = (document['locationHistory'] as List<dynamic>)
            .map((locationData) => LocationHistory.fromDocument(locationData))
            .toList(),
        status = ReservationStatusExtension.fromString(document['status']),
        super.fromDocument(document);

  bool get isHandshakeMade => isConfirmed || isUserOnTheWay || isParked;

  bool get isWaitingToGo =>
      isConfirmed && isInProgress && !isUserOnTheWay && !isParked;

  bool get isActive =>
      isPaymentApproved || isConfirmed || isUserOnTheWay || isParked;

  bool get isPendingPayment => status == ReservationStatus.pendingPayment;

  bool get isPaymentApproved => status == ReservationStatus.paymentApproved;

  bool get isConfirmed => status == ReservationStatus.confirmed;

  bool get isUserOnTheWay => status == ReservationStatus.userOnTheWay;

  bool get isParked => status == ReservationStatus.parked;

  bool get isInProgress => !isConcluded && !isCanceled && !isPaymentDenied;

  bool get isScheduled =>
      isInProgress && startDate.difference(DateTime.now()).inSeconds > 0;


  bool get isConcluded => status == ReservationStatus.concluded;

  bool get isPaymentTimeOut => status == ReservationStatus.paymentTimeOut;

  bool get isCanceled =>
      status == ReservationStatus.canceled || isPaymentTimeOut;

  bool get isPaymentDenied => status == ReservationStatus.paymentDenied;


  bool get isDone => isConcluded || isCanceled || isPaymentDenied;

  bool get isError => status == ReservationStatus.error;
}
