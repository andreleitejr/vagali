import 'package:flutter/material.dart';
import 'package:vagali/features/payment/models/payment_method.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

class PaymentMethodListItem extends StatelessWidget {
  final PaymentMethodItem paymentMethod;

  const PaymentMethodListItem({
    super.key,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(paymentMethod.image),
      title: Text(
        paymentMethod.name!,
        style: ThemeTypography.semiBold14,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paymentMethod.description != null)
            Text(
              paymentMethod.description!,
              style: ThemeTypography.regular12.apply(
                color: ThemeColors.grey4,
              ),
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
