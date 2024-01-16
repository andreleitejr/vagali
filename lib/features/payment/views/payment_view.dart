import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/tenant/views/base_view.dart';
import 'package:vagali/features/payment/controllers/payment_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class PaymentView extends GetView<PaymentController> {
  final Reservation reservation;

  const PaymentView({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: TopNavigationBar(
        title: 'Pagamento com Cartão de Crédito',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF009C7B),
                          Color(0xFF00517C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 60,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFC9A012),
                                Color(0xFFFFE999),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.maskedCardNumber.value,
                          style: ThemeTypography.semiBold16.apply(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.maskedCardHolderName.value
                                    .toUpperCase(),
                                style: ThemeTypography.regular14.apply(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              controller.maskedExpiryDate.value,
                              style: ThemeTypography.semiBold14.apply(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Input(
                  onChanged: controller.cardNumberController,
                  keyboardType: TextInputType.number,
                  hintText: 'Número do cartão',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CartaoBancarioInputFormatter(),
                  ],
                ),
                const SizedBox(height: 16),
                Input(
                  onChanged: controller.cardHolderNameController,
                  keyboardType: TextInputType.name,
                  hintText: 'Nome do proprietário',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Input(
                        onChanged: controller.expiryDateController,
                        keyboardType: TextInputType.datetime,
                        hintText: 'Data de validade',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          ValidadeCartaoInputFormatter()
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 128,
                      child: Input(
                        onChanged: controller.cvvCodeController,
                        keyboardType: TextInputType.number,
                        hintText: 'CCV',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valor total:',
                        style: ThemeTypography.regular12,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'R\$${reservation.totalCost}',
                            style: ThemeTypography.semiBold22,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: RoundedGradientButton(
                    actionText: ' Pagar',
                    onPressed: () {
                      controller
                          .processPayment(reservation.totalCost)
                          .then((result) async {
                        if (result == PaymentResult.approved) {
                          await Future.delayed(const Duration(seconds: 3));
                          await controller.updatePaymentReservationStatus(
                              ReservationStatus.paymentApproved);

                          Get.snackbar('Reserva feita com sucesso',
                              'Sua reserva foi realizada com sucesso. Agora é só aguarda aprovação do locador.');
                        }
                      });

                      Get.off(() => const BaseView(selectedIndex: 2));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
