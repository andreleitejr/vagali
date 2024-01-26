// item_search_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/vehicle/widgets/vehicle_edit_widget.dart';
import 'package:vagali/features/item/controllers/item_edit_controller.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/views/item_list_view.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/input_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ParkingSearchView extends StatelessWidget {
  final controller = Get.put(ItemEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(title: 'O que gostaria de guardar?'),
      body: Obx(
        () {
          if (controller.selectedItemType.value != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (controller.selectedItemType.value?.type ==
                      ItemType.vehicle) ...[
                    InputButton(
                      // onChanged: controller.vehicleTypeController,
                      controller: TextEditingController(),
                      hintText: 'Tipo de veículo',
                      onTap: () => showVehicleTypeBottomSheet(
                        context,
                        onItemSelected: controller.selectedVehicleType,
                      ),
                    ),
                  ] else ...[
                    Obx(
                      () => Input(
                        onChanged: controller.width,
                        hintText: 'Altura',
                        // error: controller.getError(controller.yearError),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        // currentFocusNode: yearFocus,
                        onSubmit: () {},
                      ),
                    ),
                    Obx(
                      () => Input(
                        onChanged: controller.width,
                        hintText: 'Largura',
                        // error: controller.getError(controller.yearError),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        // currentFocusNode: yearFocus,
                        onSubmit: () {},
                      ),
                    ),
                    Obx(
                      () => Input(
                        onChanged: controller.width,
                        hintText: 'Profundidade',
                        // error: controller.getError(controller.yearError),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        // currentFocusNode: yearFocus,
                        onSubmit: () {},
                      ),
                    ),
                  ],
                  // _buildTextField('Select Location', controller.selectedLocation),
                  // _buildDatePicker(
                  //     'Select Check-In Date', controller.selectedCheckInDate),
                  // _buildDatePicker(
                  //     'Select Check-Out Date', controller.selectedCheckOutDate),
                  ElevatedButton(
                    onPressed: () {
                      // controller.saveReservation();
                    },
                    child: Text('Save Reservation'),
                  ),
                ],
              ),
            );
          }
          return Container();
          // return ItemTypeListView();
        },
      ),
    );
  }

  // Widget _buildDropdown<T>(
  //   String label,
  //   ItemType selectedItem,
  // ) {
  //   return DropdownButtonFormField<String>(
  //     decoration: InputDecoration(labelText: label),
  //     value: selectedItem.name,
  //     items: itemTypes.map((item) {
  //       return DropdownMenuItem<String>(
  //         value: item.name,
  //         child: Text(item
  //             .toString()), // You may need to customize this based on your model
  //       );
  //     }).toList(),
  //     onChanged: (value) {
  //       selectedItem = value;
  //     },
  //   );
  // }

  Widget _buildTextField(String label, RxString textController) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        textController.value = value;
      },
    );
  }

  Widget _buildDatePicker(String label, Rx<DateTime?> dateController) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? selectedDate = await showDatePicker(
          context: Get.overlayContext!,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (selectedDate != null) {
          dateController.value = selectedDate;
        }
      },
      child: Text(label),
    );
  }
}
