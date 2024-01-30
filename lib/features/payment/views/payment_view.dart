import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/payment/controllers/payment_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';

class PaymentView extends StatefulWidget {
  final Reservation reservation;

  const PaymentView({super.key, required this.reservation});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late PaymentController paymentController;

  @override
  void initState() {
    paymentController = Get.put(PaymentController(widget.reservation));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment View'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: paymentController.paymentMethodId.value,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    paymentController.selectPaymentMethod(newValue);
                  }
                },
                items: paymentController.paymentMethods
                    .map<DropdownMenuItem<String>>(
                  (Map<String, dynamic> method) {
                    return DropdownMenuItem<String>(
                      value: method['id'],
                      child: Text(method['name']),
                    );
                  },
                ).toList(),
                hint: Text('Escolha o método de pagamento'),
              ),
              TextField(
                controller: paymentController.cardNumberController,
                decoration: InputDecoration(labelText: 'Número do Cartão'),
              ),
              TextField(
                controller: paymentController.expirationDateController,
                decoration: InputDecoration(labelText: 'Data de Validade'),
              ),
              TextField(
                controller: paymentController.ccvController,
                decoration: InputDecoration(labelText: 'CCV'),
              ),
              ElevatedButton(
                onPressed: () {
                  paymentController.makePayment();
                },
                child: Text('Make Payment'),
              ),
              GetBuilder<PaymentController>(
                builder: (controller) {
                  return Text('Request Body: ${controller.requestBody}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
