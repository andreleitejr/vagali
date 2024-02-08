// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vagali/features/reservation/models/reservation.dart';
// import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
//
// enum PaymentResult {
//   approved,
//   declined,
//   canceled,
//   error,
// }
//
// class PaymentController extends GetxController {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final ReservationRepository _reservationRepository = Get.find();
//
//   final cardNumberController = ''.obs;
//   final cardHolderNameController = ''.obs;
//   final expiryDateController = ''.obs;
//   final cvvCodeController = ''.obs;
//   var maskedCardNumber = 'XXXX XXXX XXXX XXXX'.obs;
//   var maskedCardHolderName = 'SEU NOME'.obs;
//   var maskedExpiryDate = '00/00'.obs;
//
//   final Reservation reservation;
//
//   PaymentController(this.reservation);
//
//   @override
//   void onInit() {
//     ever(cardNumberController, (callback) {
//       if (cardNumberController.value.length >= 16) {
//         maskedCardNumber.value =
//             '**** **** **** ${cardNumberController.value.substring(cardNumberController.value.length - 4)}';
//       }
//     });
//     ever(cardHolderNameController, (callback) {
//       if (cardHolderNameController.value.length >= 3) {
//         maskedCardHolderName.value = cardHolderNameController.value;
//       }
//     });
//
//     ever(expiryDateController, (callback) {
//       if (expiryDateController.value.length >= 4) {
//         maskedExpiryDate.value = expiryDateController.value;
//       }
//     });
//
//     super.onInit();
//   }
//
//   bool isCvvFocused = false;
//
//
//   Future<void> updatePaymentReservationStatus(ReservationStatus status) async {
//     try {
//       await _reservationRepository.updateReservationStatus(
//         reservation.id!,
//         status,
//       );
//     } catch (error) {
//       // await _reservationRepository.updateReservationStatus(
//       //   reservation.id!,
//       //   ReservationStatus.error,
//       // );
//       rethrow;
//     }
//   }
// // void onCreditCardModelChange(CreditCardModel creditCardModel) {
// //   cardNumber = creditCardModel.cardNumber;
// //   cardHolderName = creditCardModel.cardHolderName;
// //   expiryDate = creditCardModel.expiryDate;
// //   cvvCode = creditCardModel.cvvCode;
// //   isCvvFocused = creditCardModel.isCvvFocused;
// // }
// }
