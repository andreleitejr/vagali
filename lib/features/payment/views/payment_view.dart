import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/home/views/base_view.dart';
import 'package:vagali/features/payment/controllers/payment_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/copy_button.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class PaymentView extends StatefulWidget {
  final Reservation reservation;

  const PaymentView({super.key, required this.reservation});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late PaymentController controller;

  @override
  void initState() {
    controller = Get.put(PaymentController(widget.reservation));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Pagamento via Pix',
      ),
      body: Column(
        children: [
          /// QR CODE

          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: ThemeColors.primary,
                ),
                borderRadius: BorderRadius.circular(4)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'images/qrcode.jpg',
                width: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
          ),

          const SizedBox(height: 24),
          CopyButton(
            title: 'Chave Pix',
            description: '8c82be8b-3dff-4fa3-bc4e-da6e22e203b9',
            snackBarMessage: 'Chave pix copiada com sucesso',
          ),
          const SizedBox(height: 24),
          CopyButton(
            title: 'Pix Copia e Cola',
            description:
                '00020126580014br.gov.bcb.pix01368c82be8b-3dff-4fa3-bc4e-da6e22e203b95204000053039865802BR5923Andre Luiz Leite Junior6009Sao Paulo62070503***63040DF9',
            snackBarMessage: 'Pix copiado com sucesso',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status do pagamento',
                        style: ThemeTypography.semiBold16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Text(
                          controller.isApproved.isTrue
                              ? ReservationStatus.paymentApproved.message
                              : awaitingPaymentMessage(),
                          style: ThemeTypography.regular14.apply(
                            // color: widget.hasError ? Colors.red : ThemeColors.grey4,
                            color: controller.isApproved.isTrue
                                ? ThemeColors.primary
                                : controller.isCountdownFinished.isTrue
                                    ? ThemeColors.red
                                    : ThemeColors.grey4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Obx(
                () => TextButton(
                  onPressed: () {
                    if (controller.isApproved.isTrue) {
                      Get.offAll(() => BaseView(selectedIndex: 2));
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: controller.isApproved.isTrue
                        ? ThemeColors.primary
                        : controller.isCountdownFinished.isTrue
                            ? ThemeColors.red
                            : ThemeColors.grey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Coolicon(
                        icon: controller.isApproved.isTrue
                            ? Coolicons.circleCheckOutline
                            : Coolicons.clock,
                        color: Colors.white,
                        width: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.isApproved.isTrue
                            ? 'Ir para reserva'
                            : awaitingPaymentMessage(),
                        style: ThemeTypography.semiBold16
                            .apply(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RichText(
              text: TextSpan(
                style: ThemeTypography.semiBold12.apply(
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Importante: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Os pagamentos podem levar até 15 minutos para serem aprovados.',
                    style: ThemeTypography.regular12.apply(
                      color: ThemeColors.grey4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String awaitingPaymentMessage() {
    return 'Aguardando pagamento (${controller.minutes.value.toString().padLeft(2, '0')}'
        ':${controller.seconds.value.toString().padLeft(2, '0')})';
  }
}
