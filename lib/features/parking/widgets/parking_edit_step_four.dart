import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/parking/controllers/parking_edit_controller.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
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
          Obx(() {

            return ChipSelector<ParkingTag>(
              items: parkingTags,
              selectedItems: controller.parkingTags,
              error: controller.getError(controller.tagsError),
            );
          }),
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
