import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/address/controllers/address_edit_controller.dart';
import 'package:vagali/features/address/widgets/address_edit_widget.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class AddressEditView extends StatefulWidget {
  AddressEditView({super.key});

  @override
  State<AddressEditView> createState() => _AddressEditViewState();
}

class _AddressEditViewState extends State<AddressEditView> {
  late AddressEditController controller;

  @override
  void initState() {
    controller = Get.put(AddressEditController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Editar endereço',
        actions: [
          // Obx(
          //   () => TextButton(
          //     onPressed: () async {
          //       if (controller.isAddressValid.isTrue) {
          //         Get.back();
          //         final result = await controller.save();
          //
          //         if (result != SaveResult.success) {
          //           snackBar(
          //             'Erro ao atualizar',
          //             'Houve um erro ao atualizar',
          //           );
          //         }
          //       } else {
          //         controller.showErrors(true);
          //         debugPrint('Is Invalid.');
          //       }
          //     },
          //     child: Text(
          //       'Salvar',
          //       style: ThemeTypography.medium14.apply(
          //         color: controller.isAddressValid.isTrue
          //             ? ThemeColors.primary
          //             : ThemeColors.grey3,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AddressEditWidget(controller: controller),
      ),
    );
  }
}
