import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:vagali/features/home/views/base_view.dart';
import 'package:vagali/features/payment/controllers/payment_controller.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/custom_icon.dart';
import 'package:vagali/widgets/copy_button.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class PaymentPixView extends StatefulWidget {
  final Reservation reservation;

  const PaymentPixView({super.key, required this.reservation});

  @override
  State<PaymentPixView> createState() => _PaymentPixViewState();
}

class _PaymentPixViewState extends State<PaymentPixView> {
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
          const SizedBox(height: 24),
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
                      CustomIcon(
                        icon: controller.isApproved.isTrue
                            ? ThemeIcons.circleCheckOutline
                            : ThemeIcons.clock,
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

class PaymentCreditCardView extends StatefulWidget {
  final Reservation reservation;

  PaymentCreditCardView({super.key, required this.reservation});

  @override
  State<PaymentCreditCardView> createState() => _PaymentCreditCardViewState();
}

class _PaymentCreditCardViewState extends State<PaymentCreditCardView> {
  final creditCardController = CardEditController();

  late PaymentController controller;

  @override
  void initState() {
    controller = PaymentController(widget.reservation);

    creditCardController.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  void dispose() {
    creditCardController.removeListener(update);
    creditCardController.dispose();
    super.dispose();
  }

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
                          ThemeColors.primary,
                          Color(0xFF008a6c),
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
                                '${controller.tenant.firstName} ${controller.tenant.lastName}'
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
                //       const SizedBox(height: 16),
                // Input(
                //   onChanged: (value) {
                //     controller.cardNumberController(value);
                //
                //     if (controller.cardNumberController.value.length == 19) {
                //       creditCardController.details = CardFieldInputDetails(
                //         number: controller.cardNumberController.value,
                //         complete: false,
                //       );
                //     }
                //   },
                //   keyboardType: TextInputType.number,
                //   hintText: 'Número do cartão',
                //   inputFormatters: [
                //     FilteringTextInputFormatter.digitsOnly,
                //     CartaoBancarioInputFormatter(),
                //   ],
                // ),
                //       const SizedBox(height: 16),
                //       Input(
                //         onChanged: controller.cardHolderNameController,
                //         keyboardType: TextInputType.name,
                //         hintText: 'Nome do proprietário',
                //       ),
                //       const SizedBox(height: 16),
                //       Row(
                //         children: [
                //           Expanded(
                //             child: Input(
                //               onChanged: controller.expiryDateController,
                //               keyboardType: TextInputType.datetime,
                //               hintText: 'Data de validade',
                //               inputFormatters: [
                //                 FilteringTextInputFormatter.digitsOnly,
                //                 ValidadeCartaoInputFormatter()
                //               ],
                //             ),
                //           ),
                //           const SizedBox(width: 16),
                //           SizedBox(
                //             width: 128,
                //             child: Input(
                //               onChanged: controller.cvvCodeController,
                //               keyboardType: TextInputType.number,
                //               hintText: 'CCV',
                //             ),
                //           ),
                //         ],
                //       ),

                const SizedBox(height: 24),
                CardField(
                  autofocus: true,
                  androidPlatformViewRenderType:
                      AndroidPlatformViewRenderType.androidView,
                  enablePostalCode: false,

                  numberHintText: '**** **** **** 0000',
                  expirationHintText: 'MM/AA',
                  style: ThemeTypography.regular14,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: ThemeColors.grey1,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: ThemeColors.grey2,
                        width: 1,
                      ),
                    ),
                  ),
                  controller: creditCardController,
                  onCardChanged: (cardDetails) {
                    if (cardDetails != null) {
                      if (cardDetails.number != null) {
                        controller.maskedCardNumber.value =
                            '**** **** **** ${cardDetails.number!.substring(cardDetails.number!.length - 4)}';
                      }
                      if (cardDetails.expiryMonth != null &&
                          cardDetails.expiryYear != null) {
                        final date =
                            '${cardDetails.expiryMonth}/${cardDetails.expiryYear}';
                        controller.maskedExpiryDate.value = date;
                      }
                      if (cardDetails.cvc != null &&
                          cardDetails.expiryMonth != null &&
                          cardDetails.expiryYear != null &&
                          cardDetails.number != null) {
                        Focus.of(context).unfocus();
                      }
                    }
                  },
                  // style: CardFormStyle(
                  //   cursorColor: ThemeColors.primary,
                  //   borderColor: Colors.white,
                  //   borderWidth: 1,
                  // ),
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
                            'R\$${controller.reservation.totalCost}',
                            style: ThemeTypography.semiBold22,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    actionText: ' Pagar',
                    onPressed: () {
                      controller.handlePayPress();
                      Get.snackbar('Reserva feita com sucesso',
                          'Sua reserva foi realizada com sucesso. Agora é só aguarda aprovação do locador.');

                      Get.to(() => const BaseView(selectedIndex: 2));
                      // controller
                      //     .processPayment(reservation.totalCost)
                      //     .then((result) async {
                      //   if (result == PaymentResult.approved) {
                      //     await Future.delayed(const Duration(seconds: 3));
                      //     await controller.updatePaymentReservationStatus(
                      //         ReservationStatus.paymentApproved);
                      //
                      //     Get.snackbar('Reserva feita com sucesso',
                      //         'Sua reserva foi realizada com sucesso. Agora é só aguarda aprovação do locador.');
                      //
                      //     Get.to(() => const BaseView(selectedIndex: 2));
                      //   }
                      // });
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

//
// class PaymentCreditCardView extends GetView<PaymentController> {
//   final Reservation reservation;
//
//   const PaymentCreditCardView({
//     super.key,
//     required this.reservation,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       appBar: TopNavigationBar(
//         title: 'Pagamento com Cartão de Crédito',
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Obx(() {
//                   return Container(
//                     padding: const EdgeInsets.all(24),
//                     height: 220,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(32),
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF009C7B),
//                           Color(0xFF00517C),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 42,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFFC9A012),
//                                 Color(0xFFFFE999),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           controller.maskedCardNumber.value,
//                           style: ThemeTypography.semiBold16.apply(
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 controller.maskedCardHolderName.value
//                                     .toUpperCase(),
//                                 style: ThemeTypography.regular14.apply(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               controller.maskedExpiryDate.value,
//                               style: ThemeTypography.semiBold14.apply(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 16),
//                 Input(
//                   onChanged: controller.cardNumberController,
//                   keyboardType: TextInputType.number,
//                   hintText: 'Número do cartão',
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     CartaoBancarioInputFormatter(),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Input(
//                   onChanged: controller.cardHolderNameController,
//                   keyboardType: TextInputType.name,
//                   hintText: 'Nome do proprietário',
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Input(
//                         onChanged: controller.expiryDateController,
//                         keyboardType: TextInputType.datetime,
//                         hintText: 'Data de validade',
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           ValidadeCartaoInputFormatter()
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     SizedBox(
//                       width: 128,
//                       child: Input(
//                         onChanged: controller.cvvCodeController,
//                         keyboardType: TextInputType.number,
//                         hintText: 'CCV',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 100,
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Valor total:',
//                         style: ThemeTypography.regular12,
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(
//                             'R\$${reservation.totalCost}',
//                             style: ThemeTypography.semiBold22,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: FlatButton(
//                     actionText: ' Pagar',
//                     onPressed: () {
//                       // controller
//                       //     .processPayment(reservation.totalCost)
//                       //     .then((result) async {
//                       //   if (result == PaymentResult.approved) {
//                       //     await Future.delayed(const Duration(seconds: 3));
//                       //     await controller.updatePaymentReservationStatus(
//                       //         ReservationStatus.paymentApproved);
//                       //
//                       //     Get.snackbar('Reserva feita com sucesso',
//                       //         'Sua reserva foi realizada com sucesso. Agora é só aguarda aprovação do locador.');
//                       //
//                       //     Get.to(() => const BaseView(selectedIndex: 2));
//                       //   }
//                       // });
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
