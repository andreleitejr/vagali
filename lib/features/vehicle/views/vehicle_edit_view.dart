import 'package:flutter/material.dart';
import 'package:vagali/features/vehicle/controllers/vehicle_edit_controller.dart';
import 'package:vagali/features/vehicle/widgets/vehicle_edit_widget.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class VehicleEditView extends StatelessWidget {
  const VehicleEditView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopNavigationBar(
        showLeading: false,
        title: 'Editar veículo',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: VehicleEditWidget(
          controller: VehicleEditController(),
          allowToSkip: true,
        ),
      ),
    );
  }
}
