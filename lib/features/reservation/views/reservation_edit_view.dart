import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/views/item_type_list_view.dart';
import 'package:vagali/features/payment/views/payment_view.dart';
import 'package:vagali/features/reservation/controllers/reservation_edit_controller.dart';
import 'package:vagali/features/reservation/widgets/reservation_date_widget.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/title_with_icon.dart';

class ReservationEditView extends StatefulWidget {
  final Parking parking;

  const ReservationEditView({Key? key, required this.parking})
      : super(key: key);

  @override
  _ReservationEditViewState createState() => _ReservationEditViewState();
}

class _ReservationEditViewState extends State<ReservationEditView> {
  late ReservationEditController controller;

  @override
  void initState() {
    controller = Get.put(ReservationEditController(parking: widget.parking));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (controller.showItemTypeList.isTrue) {
              controller.showItemTypeList.value = false;
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeColors.grey4,
          ),
        ),
        title: Obx(
          () => Text(
            controller.showItemTypeList.isTrue
                ? 'O que gostaria de guardar?'
                : 'Minha reserva',
            style: ThemeTypography.medium16.apply(
              color: ThemeColors.grey4,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.showItemTypeList.isTrue) {
          return ItemTypeListView(
            onItemSelected: (item) {
              controller.item.value = item;
              controller.showItemTypeList.value = false;
            },
          );
        }
        return ListView(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => controller.showItemTypeList(true),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'O que gostaria de guardar?',
                          style: ThemeTypography.semiBold16,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getItemTitle(),
                          style: ThemeTypography.regular14.apply(
                            // color: widget.hasError ? Colors.red : ThemeColors.grey4,
                            color: ThemeColors.grey4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              width: double.infinity,
              height: 0.75,
              color: ThemeColors.grey3,
            ),
            Obx(
              () => ReservationDateWidget(
                onDatesSelected: controller.onDatesSelected,
                initialStartDate: controller.startDate.value,
                initialEndDate: controller.endDate.value,
                hasError: controller.showErrors.value,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AddressCard(
                address: controller.parking.address,
                editModeOn: false,
              ),
            ),
            // SizedBox(
            //   height: 200,
            //   child: Obx(
            //     () {
            //       if (_controller.parkingMarkerIcon.value == null) {
            //         return Container();
            //       }
            //       return GoogleMap(
            //         initialCameraPosition: CameraPosition(
            //           target: LatLng(
            //             _controller.parking.location.latitude + 0.0010,
            //             _controller.parking.location.longitude,
            //           ),
            //           zoom: 17,
            //         ),
            //         markers: {
            //           Marker(
            //             markerId: const MarkerId('location'),
            //             position: LatLng(
            //               _controller.parking.location.latitude,
            //               _controller.parking.location.longitude,
            //             ),
            //             icon: _controller.parkingMarkerIcon.value!,
            //           ),
            //         },
            //         onMapCreated: (GoogleMapController controller) {
            //           _controller.loadMapStyle(controller);
            //         },
            //       );
            //     },
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(24),
            //       topRight: Radius.circular(24),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.25),
            //         spreadRadius: -8,
            //         blurRadius: 20,
            //         offset: const Offset(0, 0),
            //       ),
            //     ],
            //   ),
            //   constraints: BoxConstraints(
            //     maxHeight: MediaQuery.of(context).size.height * 0.4,
            //   ),
            //   child: ListView(
            //     children: [
            //       // Column(
            //       //   crossAxisAlignment: CrossAxisAlignment.start,
            //       //   children: [
            //       //     const SizedBox(height: 8),
            //       //     Obx(
            //       //       () => DatePeriod(
            //       //           startDate: _controller.startDate.value,
            //       //           endDate: _controller.endDate.value),
            //       //     ),
            //       //   ],
            //       // ),
            //       // const SizedBox(height: 16),
            //       // if (_controller.userHasVehicle()) ...[
            //       //   VehicleInfoWidget(vehicle: _controller.vehicles.first),
            //       // ] else
            //       //   Container(),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TitleWithIcon(
                    title: 'Mensagem (opcional)',
                    icon: Coolicons.chatDots,
                  ),
                  const SizedBox(height: 12),
                  Input(
                    onChanged: controller.reservationMessageController,
                    hintText: 'Enviar mensagem ao locador (opcional)',
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => Container(
          height: controller.showItemTypeList.isTrue ? 0 : 100,
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
                        Obx(
                          () => Text(
                            'R\$${controller.totalCost.value}',
                            style: ThemeTypography.semiBold22,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: FlatButton(
                  actionText: 'Pagar',
                  onPressed: () async {
                    if (controller.isValid()) {
                      final result = await controller.createReservation();
                      if (result == SaveResult.success) {
                        initiatePayment();
                      } else {
                        Get.snackbar('Erro ao salvar reserva',
                            'Houve um erro inesperado ao salvar sua reserva. Tenve novamente.');
                      }
                    } else {
                      controller.showErrors(true);
                      debugPrint('Inválido.');
                      Get.snackbar('Data inválida',
                          'A data de início e a data de fim são obrigatória',
                          backgroundColor: Colors.red.withOpacity(0.75),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getItemTitle() {
    if (controller.item.value != null) {
      final title = itemTypes
          .firstWhere((item) => item.type == controller.item.value!.type)
          .name!;
      return title;
    } else {
      return 'Veículos, estoques, móveis, compras...';
    }
  }

  void initiatePayment() async {
    // Get.put(PaymentController(controller.reservation.value!));
    Get.to(
      () => PaymentView(
        reservation: controller.reservation.value!,
      ),
    );
  }
}
