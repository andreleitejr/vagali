import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/payment/models/payment_method.dart';
import 'package:vagali/features/payment/widgets/payment_method_list_item.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class PaymentMethodSelectionView extends StatelessWidget {
  const PaymentMethodSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Método de pagamento',
      ),
      body: ListView.builder(
        itemCount: paymentMethods.length,
        itemBuilder: (context, index) {
          final paymentMethod = paymentMethods[index];
          return InkWell(
            onTap: () {
              Get.back(result: paymentMethod);
            },
            child: PaymentMethodListItem(paymentMethod: paymentMethod),
          );
        },
      ),
    );
  }
}
