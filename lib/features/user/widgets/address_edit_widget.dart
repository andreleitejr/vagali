import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/widgets/input.dart';

class AddressEditWidget extends StatefulWidget {
  final UserEditController controller;

  AddressEditWidget({super.key, required this.controller});

  @override
  State<AddressEditWidget> createState() => _AddressEditWidgetState();
}

class _AddressEditWidgetState extends State<AddressEditWidget> {
  final FocusNode postalCodeFocus = FocusNode();

  final FocusNode streetFocus = FocusNode();

  final FocusNode numberFocus = FocusNode();

  final FocusNode cityFocus = FocusNode();

  final FocusNode stateFocus = FocusNode();

  final FocusNode countryFocus = FocusNode();

  final FocusNode complementFocus = FocusNode();

  @override
  void initState() {
    postalCodeFocus.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Input(
          controller: widget.controller.postalCodeController,
          hintText: 'CEP',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CepInputFormatter(),
          ],
          currentFocusNode: postalCodeFocus,
          nextFocusNode: numberFocus,
        ),
        const SizedBox(height: 16),
        Input(
          controller: widget.controller.streetController,
          keyboardType: TextInputType.streetAddress,
          hintText: 'Rua',
          currentFocusNode: streetFocus,
          nextFocusNode: numberFocus,
        ),
        const SizedBox(height: 16),
        Input(
          controller: widget.controller.numberController,
          // keyboardType: TextInputType.number,
          hintText: 'Número',
          currentFocusNode: numberFocus,
          nextFocusNode: complementFocus,
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            controller: widget.controller.cityController,
            hintText: 'Cidade',
            error: widget.controller.getError(widget.controller.cityError),
            currentFocusNode: cityFocus,
            nextFocusNode: stateFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            controller: widget.controller.stateController,
            hintText: 'Estado',
            error: widget.controller.getError(widget.controller.stateError),
            currentFocusNode: stateFocus,
            nextFocusNode: countryFocus,
          ),
        ),
        const SizedBox(height: 16),
        Input(
          controller: widget.controller.countryController,
          hintText: 'País',
          currentFocusNode: countryFocus,
          nextFocusNode: complementFocus,
        ),
        const SizedBox(height: 16),
        Input(
          controller: widget.controller.complementController,
          hintText: 'Complemento',
          currentFocusNode: complementFocus,
          onSubmit: () => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
