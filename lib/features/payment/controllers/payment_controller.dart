import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/services/payment_service.dart';

class PaymentController extends GetxController {
  PaymentController(this.reservation);

  final Reservation reservation;
  final User tenant = Get.find();
  var requestBody = <String, dynamic>{}.obs;
  final paymentService = PaymentService();

  var paymentMethods = <Map<String, dynamic>>[].obs;
  final paymentMethodId = ''.obs;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController ccvController = TextEditingController();

  void selectPaymentMethod(String methodId) {
    paymentMethodId.value = methodId;
  }

  void updateRequestBody() {
    final newData = {
      "application_fee": 6,
      "binary_mode": false,
      "campaign_id": null,
      "capture": false,
      "coupon_amount": null,
      "description": "Reserva de vaga",
      "differential_pricing_id": null,
      "external_reference": "MP0001",
      "installments": 1,
      "metadata": null,
      "payer": {
        "entity_type": "individual",
        "type": "customer",
        "email": tenant.email,
        "identification": {
          "type": "CPF",
          "number": tenant.document,
        }
      },
      "payment_method_id": paymentMethodId.value,
      "token": "ff8080814c11e237014c1ff593b57b4d",
      "transaction_amount": reservation.totalCost,
    };

    requestBody.value = newData;
  }

  Future<void> makePayment() async {
    updateRequestBody();
    final response = await paymentService.makePayment(requestBody);
    print('Payment Response: $response');
  }

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    try {
      final methods = await paymentService.fetchPaymentMethods();
      paymentMethods.assignAll(methods);
    } catch (e) {
      print('Error fetching payment methods: $e');
    }
  }
}
