import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/payment/models/payment_method.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/location_history.dart';
import 'package:vagali/utils/extensions.dart';

enum ReservationStatus {
  pendingPayment,
  paymentApproved,
  paymentDenied,
  paymentTimeOut,
  confirmationTimeOut,
  confirmed,
  inProgress,
  userOnTheWay,
  arrived,
  parked,
  concluded,
  canceled,
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
  final String paymentMethod;

  Landlord? landlord;
  Tenant? tenant;
  Parking? parking;
  Item? item;

  Reservation({
    required super.id,
    required super.createdAt,
    required super. updatedAt,
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
    required this.paymentMethod,
  });

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
        paymentMethod = document['paymentMethod'],
        super.fromDocument(document);

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
      'paymentMethod': paymentMethod,
      ...super.toMap(),
    };
  }

  bool get isHandshakeMade =>
      isConfirmed || /*isUserOnTheWay ||*/ isParked || isInProgress;

  bool get isWaitingToGo =>
      isConfirmed && isOpen && !isUserOnTheWay && !isParked;

  bool get isActive =>
      isPaymentApproved ||
      isConfirmed ||
      isUserOnTheWay ||
      isParked ||
      isInProgress;

  bool get isPendingPayment => status == ReservationStatus.pendingPayment;

  bool get isPaymentApproved => status == ReservationStatus.paymentApproved;

  bool get isConfirmed => status == ReservationStatus.confirmed;

  bool get isUserOnTheWay => status == ReservationStatus.userOnTheWay;

  bool get isArrived => status == ReservationStatus.arrived;

  bool get isParked => status == ReservationStatus.parked;

  bool get isOpen =>
      // !isConfirmationExpired &&
      !isDone;

  bool get isConfirmationExpired =>
      isPaymentApproved && endDate.isAfter(DateTime.now());

  bool get isExpired => endDate.isBefore(DateTime.now());

  /// MEU IS IN PROGRESS
  bool get isInProgress => status == ReservationStatus.inProgress;

  bool get isScheduled =>
      isOpen && startDate.difference(DateTime.now()).inSeconds > 0;

  bool get isConcluded => status == ReservationStatus.concluded;

  bool get isPaymentTimeOut => status == ReservationStatus.paymentTimeOut;

  bool get isConfirmationTimeOut =>
      status == ReservationStatus.confirmationTimeOut;

  bool get isCanceled =>
      status == ReservationStatus.canceled || isPaymentTimeOut;

  bool get isPaymentDenied => status == ReservationStatus.paymentDenied;

  bool get isDone =>
      isConcluded ||
      isCanceled ||
      isPaymentDenied ||
      isExpired ||
      isConfirmationTimeOut;

  bool get isError => status == ReservationStatus.error;
}
