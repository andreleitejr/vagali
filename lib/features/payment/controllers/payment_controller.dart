import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:vagali/features/payment/models/payment_method.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/payment_service.dart';

class PaymentController extends GetxController {
  final User tenant = Get.find();

  PaymentController(this.reservation);

  final _paymentService = PaymentService();
  final _reservationRepository = Get.put(ReservationRepository());

  final cardDetails = Rx<CardFieldInputDetails?>(null);
  final cardNumberController = ''.obs;
  final cardHolderNameController = ''.obs;
  final expiryDateController = ''.obs;
  final cvvCodeController = ''.obs;
  var maskedCardNumber = 'XXXX XXXX XXXX XXXX'.obs;
  var maskedCardHolderName = 'SEU NOME'.obs;
  var maskedExpiryDate = '00/00'.obs;

  final Reservation reservation;
  final status = Rx<ReservationStatus?>(null);
  final minutes = 15.obs;
  final seconds = 0.obs;
  final isCountdownFinished = false.obs;

  RxBool get isApproved => (status.value != null &&
          status.value == ReservationStatus.paymentApproved)
      .obs;

  @override
  void onInit() {
    super.onInit();

    ever(cardNumberController, (callback) {
      if (cardNumberController.value.length >= 16) {
        maskedCardNumber.value =
            '**** **** **** ${cardNumberController.value.substring(cardNumberController.value.length - 4)}';
      }
    });
    ever(cardHolderNameController, (callback) {
      if (cardHolderNameController.value.length >= 3) {
        maskedCardHolderName.value = cardHolderNameController.value;
      }
    });

    ever(expiryDateController, (callback) {
      if (expiryDateController.value.length >= 4) {
        maskedExpiryDate.value = expiryDateController.value;
      }
    });

    print('HUASDHASUHUHSDAUHSDAUHDSU22 ${cardDetails.value}');
    ever(cardDetails, (callback) {
      print('HUASDHASUHUHSDAUHSDAUHDSU ${cardDetails.value}');
    });

    if (reservation.paymentMethod == PaymentMethodItem.pix) {
      _listenToReservationsStream();
      _startCountdown();
    }
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

  Future<void> handlePayPress() async {
    try {
      // creditCardController.details = CardFieldInputDetails(
      //   number: cardNumberController.value,
      //   expiryMonth: 12,
      //   expiryYear: 25,
      //   cvc: '500',
      //   complete: true,
      // );
      // 1. Gather customer billing information (ex. email)
      final billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texasssss',
          postalCode: '77063',
        ),
      );

      print(' HUSHDUAHAUSDHUASDHUASDHUASDHUA21121212 323323232322332323232');
      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      print(' HUSHDUAHAUSDHUASDHUASDHUASDHUA 323323232322332323232');
      // 3. call API to create PaymentIntent
      final paymentIntentResult =
          await _paymentService.callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'USD',
        items: ['id-1'],
      );

      if (paymentIntentResult['error'] != null) {
        // Error during creating or confirming Intent
        print('Payment Error 1: ${paymentIntentResult['error']}');

        updatePaymentReservationStatus(ReservationStatus.paymentDenied);
        return;
      }

      print(
          ' HUSHDUAHAUSDHUASDHUASDHUASDHUA 323323232322332323232 jesus093290329032');
      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        // Payment succeeded
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Success!: The payment was confirmed successfully!'),
        // ));

        print('Payment Succeeeed 1: hehehehe');
        updatePaymentReservationStatus(ReservationStatus.paymentApproved);
        return;
      }
      print('HUSHDUAHAUSDHUASDHUASDHUASDHUA 323323232322332323232 00000000');

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        // 4. if payment requires action calling handleNextAction
        final paymentIntent = await Stripe.instance.handleNextAction(
          paymentIntentResult['clientSecret'],
          returnURL: 'flutterstripe://redirect',
        );

        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          // 5. Call API to confirm intent
          await confirmIntent(paymentIntent.id);
        } else {
          // Payment succeeded
          print('Payment Succeeded');

          updatePaymentReservationStatus(ReservationStatus.paymentApproved);
        }
      }

      if (paymentIntentResult['id'] != null) {
        updatePaymentReservationStatus(ReservationStatus.paymentApproved);
      }
      print(
          ' HUSHDUAHAUSDHUASDHUASDHUASDHUA 323323232322332323232 HAUASDHUASHUASHSDAU ${paymentIntentResult}');
    } catch (e) {
      print('Payment Error 22222222222: $e');

      updatePaymentReservationStatus(ReservationStatus.paymentDenied);
      rethrow;
    }
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await _paymentService.callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId);
    print('KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK CONFIRM INTENR');

    if (result['error'] != null) {
      updatePaymentReservationStatus(ReservationStatus.paymentDenied);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    } else {
      updatePaymentReservationStatus(ReservationStatus.paymentApproved);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Success!: The payment was confirmed successfully!')));
    }
  }

  Future<void> updatePaymentReservationStatus(ReservationStatus status) async {
    try {
      await _reservationRepository.updateReservationStatus(
        reservation.id!,
        status,
      );
    } catch (error) {
      // await _reservationRepository.updateReservationStatus(
      //   reservation.id!,
      //   ReservationStatus.error,
      // );
      rethrow;
    }
  }
}
