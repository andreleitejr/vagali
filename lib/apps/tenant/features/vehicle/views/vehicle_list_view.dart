import 'package:flutter/material.dart';
import 'package:vagali/apps/tenant/features/vehicle/widgets/vehicle_list_item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class VehicleListView extends StatelessWidget {
  final List<Vehicle> vehicles;

  VehicleListView({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Meus veículos',
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (BuildContext context, int index) {
          final vehicle = vehicles[index];

          return VehicleListItem(vehicle: vehicle);
        },
      ),
    );
  }
}
