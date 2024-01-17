import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/vehicle/controllers/vehicle_list_controller.dart';
import 'package:vagali/apps/tenant/features/vehicle/widgets/vehicle_list_item.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class VehicleListView extends StatelessWidget {
  VehicleListView({super.key});

  final controller = Get.put(VehicleListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Meus Veículo',
      ),
      body: ListView.builder(
        itemCount: controller.vehicles.length,
        itemBuilder: (BuildContext context, int index) {
          final vehicle = controller.vehicles[index];

          return VehicleListItem(vehicle: vehicle);
        },
      ),
    );
  }
}
