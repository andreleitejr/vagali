import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/parking/widgets/gate_input.dart';
import 'package:vagali/widgets/chip_selector.dart';

class StepFourWidget extends StatelessWidget {
  final ParkingEditController controller;

  const StepFourWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          Obx(
            () => ChipSelector<ParkingTag>(
              items: parkingTags,
              labelText: 'Selecione as Tags',
              onSelectionChanged: (selectedItems) =>
                  controller.parkingTags(selectedItems),
              error: controller.getError(controller.tagsError),
            ),
          ),
          Obx(
            () {
              final error = controller.getError(controller.tagsError);
              return error.isNotEmpty
                  ? Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

