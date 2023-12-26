import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/payment/controllers/payment_controller.dart';
import 'package:vagali/features/payment/views/payment_view.dart';
import 'package:vagali/features/reservation/controllers/reservation_edit_controller.dart';
import 'package:vagali/features/reservation/widgets/reservation_date_widget.dart';
import 'package:vagali/features/vehicle/widgets/vehicle_info_widget.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/date_period.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/rounded_gradient_button.dart';
import 'package:vagali/widgets/title_with_icon.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ReservationEditView extends StatefulWidget {
  final Parking parking;

  const ReservationEditView({Key? key, required this.parking})
      : super(key: key);

  @override
  _ReservationEditViewState createState() => _ReservationEditViewState();
}

class _ReservationEditViewState extends State<ReservationEditView> {
  late ReservationEditController _controller;

  @override
  void initState() {
    _controller = Get.put(ReservationEditController(parking: widget.parking));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Minha reserva',
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Obx(() {
                if (_controller.parkingMarkerIcon.value == null) {
                  return Container();
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _controller.parking.location.latitude + 0.0010,
                      _controller.parking.location.longitude,
                    ),
                    zoom: 17,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('location'),
                      position: LatLng(
                        _controller.parking.location.latitude,
                        _controller.parking.location.longitude,
                      ),
                      icon: _controller.parkingMarkerIcon.value!,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.loadMapStyle(controller);
                  },
                );
              })),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Obx(
              () => ReservationDateWidget(
                onDatesSelected: _controller.onDatesSelected,
                initialStartDate: _controller.startDate.value,
                initialEndDate: _controller.endDate.value,
                hasError: _controller.showErrors.value,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: -8,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Obx(
                        () => DatePeriod(
                            startDate: _controller.startDate.value,
                            endDate: _controller.endDate.value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_controller.userHasVehicle()) ...[
                    VehicleInfoWidget(vehicle: _controller.vehicles.first),
                  ] else
                    Container(),
                  const SizedBox(height: 16),
                  TitleWithIcon(
                    title: 'Mensagem (opcional)',
                    icon: Coolicons.chatDots,
                  ),
                  const SizedBox(height: 12),
                  Input(
                    controller: _controller.reservationMessageController,
                    hintText: 'Enviar mensagem ao locador (opcional)',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
                      Obx(
                        () => Text(
                          'R\$${_controller.totalCost.value}',
                          style: ThemeTypography.semiBold22,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: RoundedGradientButton(
                actionText: 'Pagar',
                onPressed: () async {
                  if (_controller.isValid()) {
                    final result = await _controller.createReservation();
                    if (result == SaveResult.success) {
                      initiatePayment();
                    } else {
                      Get.snackbar('Erro ao salvar reserva',
                          'Houve um erro inesperado ao salvar sua reserva. Tenve novamente.');
                    }
                  } else {
                    _controller.showErrors(true);
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
    );
  }

  void initiatePayment() async {
    Get.put(PaymentController(_controller.reservation.value!));
    Get.to(
      () => PaymentView(
        reservation: _controller.reservation.value!,
      ),
    );
  }
}
