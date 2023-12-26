import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/controllers/reservation_edit_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';

enum PaymentResult {
  approved,
  declined,
  canceled,
  error,
}

class PaymentController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ReservationRepository _reservationRepository = Get.find();

  final cardNumberController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvCodeController = TextEditingController();
  var maskedCardNumber = 'XXXX XXXX XXXX XXXX'.obs;
  var maskedCardHolderName = 'SEU NOME'.obs;
  var maskedExpiryDate = '00/00'.obs;

  final Reservation reservation;

  PaymentController(this.reservation);

  @override
  void onInit() {
    cardNumberController.addListener(() {
      if (cardNumberController.text.length >= 16) {
        maskedCardNumber.value =
            '**** **** **** ${cardNumberController.text.substring(cardNumberController.text.length - 4)}';
      }
    });
    cardHolderNameController.addListener(() {
      if (cardHolderNameController.text.length >= 3) {
        maskedCardHolderName.value = cardHolderNameController.text;
      }
    });
    expiryDateController.addListener(() {
      if (expiryDateController.text.length >= 4) {
        maskedExpiryDate.value = expiryDateController.text;
      }
    });
    super.onInit();
  }

  bool isCvvFocused = false;

  Future<PaymentResult> processPayment(double transactionAmount) async {
    final request = BraintreeCreditCardRequest(
      cardNumber: cardNumberController.text,
      expirationMonth: '12',
      expirationYear: '2021',
      cvv: '100',
    );

    final result = await Braintree.tokenizeCreditCard(
      'sandbox_8hxpnkht_kzdtzv2btm4p7s5j',
      request,
    );

    if (result != null) {
      // O pagamento foi aprovado, você pode usar as informações do nonce aqui
      final nonce = result.nonce;
      final typeLabel = result.typeLabel;
      final description = result.description;

      // Faça o que for necessário com as informações do pagamento
      print('Nonce: $nonce');
      print('Type label: $typeLabel');
      print('Description: $description');

      // Você pode realizar ações adicionais, como enviar os detalhes do pagamento para o servidor,
      // atualizar o estado do seu aplicativo, etc.
      return PaymentResult.approved;
    } else {
      // O pagamento falhou ou foi cancelado
      // Você pode tratar o erro ou informar ao usuário que o pagamento não foi aprovado
      print('Falha no pagamento ou pagamento cancelado.');
      updatePaymentReservationStatus(ReservationStatus.paymentDenied);

      return PaymentResult.declined;
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
// void onCreditCardModelChange(CreditCardModel creditCardModel) {
//   cardNumber = creditCardModel.cardNumber;
//   cardHolderName = creditCardModel.cardHolderName;
//   expiryDate = creditCardModel.expiryDate;
//   cvvCode = creditCardModel.cvvCode;
//   isCvvFocused = creditCardModel.isCvvFocused;
// }
}
