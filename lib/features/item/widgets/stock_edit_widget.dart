import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagali/features/item/controllers/item_edit_controller.dart';
import 'package:vagali/widgets/input.dart';

class StockEditWidget extends StatelessWidget {
  final ItemEditController controller;

  StockEditWidget({
    super.key,
    required this.controller,
  });

  final productTypeFocus = FocusNode();
  final productQuantityFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Input(
          onChanged: controller.productType,
          hintText: 'Tipo de Produto do Estoque',
          currentFocusNode: productTypeFocus,
          nextFocusNode: productQuantityFocus,
        ),
        const SizedBox(height: 16),
        Input(
          onChanged: (quantity) {
            final parsedQuantity = int.tryParse(quantity);
            controller.productQuantity(parsedQuantity);
          },
          hintText: 'Quantidade',
          // error: controller.getError(controller.licensePlateError),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          currentFocusNode: productQuantityFocus,
          // nextFocusNode: heightFocus,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
