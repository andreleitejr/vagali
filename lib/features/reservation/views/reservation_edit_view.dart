import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/features/address/widgets/address_card.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/features/item/views/item_list_view.dart';
import 'package:vagali/features/item/views/item_type_list_view.dart';
import 'package:vagali/features/item/widgets/item_list_item.dart';
import 'package:vagali/features/payment/models/payment_method.dart';
import 'package:vagali/features/payment/views/payment_method_selection_view.dart';
import 'package:vagali/features/payment/views/payment_pix_view.dart';
import 'package:vagali/features/reservation/controllers/reservation_edit_controller.dart';
import 'package:vagali/features/reservation/widgets/reservation_date_widget.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
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
            if (controller.showTenantItemsList.isTrue) {
              controller.showTenantItemsList.value = false;
            } else if (controller.showItemTypeList.isTrue) {
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
        if (controller.tenantItems.isNotEmpty &&
            controller.showTenantItemsList.isTrue) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.tenantItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = controller.tenantItems[index];

                    return GestureDetector(
                      onTap: (){
                        controller.item(item);
                        controller.showTenantItemsList(false);
                      },
                      child: ItemListItem(item: item),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FlatButton(
                  actionText: 'Cadastrar novo item',
                  onPressed: () {
                    controller.showItemTypeList(true);
                    controller.showTenantItemsList(false);
                  },
                ),
              ),
            ],
          );
        }
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
            itemSelection(),
            // const SizedBox(height: 16),
            Obx(
              () => ReservationDateWidget(
                onDatesSelected: controller.onDatesSelected,
                initialStartDate: controller.startDate.value,
                initialEndDate: controller.endDate.value,
                hasError: controller.showErrors.value,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final paymentMethod =
                    await Get.to(() => PaymentMethodSelectionView());
                if (paymentMethod != null) {
                  controller.paymentMethod(paymentMethod);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.grey3),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Método de pagamento',
                            style: ThemeTypography.semiBold16,
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        children: [
                          if (controller.paymentMethod.value != null) ...[
                            Image.asset(
                              controller.paymentMethod.value!.image,
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            controller.paymentMethod.value?.name ??
                                'Selecionar método de pagamento',
                            style: ThemeTypography.regular14.apply(
                              // color: widget.hasError ? Colors.red : ThemeColors.grey4,
                              color: ThemeColors.grey4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    maxLines: 3,
                  ),
                ],
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
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => Container(
          height: controller.showItemTypeList.isTrue ||
                  controller.showTenantItemsList.isTrue
              ? 0
              : 100,
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

  Widget itemSelection() {
    return GestureDetector(
      onTap: () {
        if (controller.tenantItems.isNotEmpty) {
          controller.showTenantItemsList(true);
        } else {
          controller.showItemTypeList(true);
        }
      },
      child: Container(
        color: Colors.white.withOpacity(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              width: double.infinity,
              height: 0.75,
              color: ThemeColors.grey3,
            ),
          ],
        ),
      ),
    );
  }

  String _getItemTitle() {
    if (controller.item.value != null) {
      final item = controller.item.value!;

      if (item.type == ItemType.vehicle) {
        final vehicle =
            controller.tenantVehicles.firstWhereOrNull((v) => v.id == item.id!);
        return '${vehicle?.brand} ${vehicle?.model}';
      }

      return itemTypes
          .firstWhere((item) => item.type == controller.item.value!.type)
          .name!;
    }

    return 'Veículos, estoques, móveis, compras...';
  }

  void initiatePayment() async {
    // Get.put(PaymentController(controller.reservation.value!));
    if (controller.paymentMethod.value!.title == PaymentMethodItem.pix) {
      Get.to(
        () => PaymentPixView(
          reservation: controller.reservation.value!,
        ),
      );
    } else {
      Get.to(
        () => PaymentCreditCardView(
          reservation: controller.reservation.value!,
        ),
      );
    }
  }
}
