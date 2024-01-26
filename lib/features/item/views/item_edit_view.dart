import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/tenant/features/vehicle/widgets/vehicle_edit_widget.dart';
import 'package:vagali/features/item/controllers/item_edit_controller.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/widgets/stock_edit_widget.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/image_button.dart';
import 'package:vagali/widgets/image_picker_bottom_sheet.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ItemEditView extends StatefulWidget {
  final ItemType selectedType;

  ItemEditView({required this.selectedType});

  @override
  _ItemEditViewState createState() => _ItemEditViewState();
}

class _ItemEditViewState extends State<ItemEditView> {
  final controller = Get.put(ItemEditController());
  late List<Widget> _typeSpecificFields;

  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final widthFocus = FocusNode();
  final heightFocus = FocusNode();
  final depthFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _typeSpecificFields = _buildTypeSpecificFields();
  }

  List<Widget> _buildTypeSpecificFields() {
    switch (widget.selectedType.type) {
      case ItemType.vehicle:
        return _buildVehicleFields();
      case ItemType.stock:
        return _buildStockFields();
      default:
        return [];
    }
  }

  List<Widget> _buildVehicleFields() {
    return [
      VehicleEditWidget(controller: controller),
      // Add more vehicle-specific fields as needed
    ];
  }

  List<Widget> _buildStockFields() {
    final stockFields = <Widget>[];
    stockFields.add(StockEditWidget(controller: controller));
    stockFields.addAll(_buildItemFields());
    return stockFields;
  }

  List<Widget> _buildItemFields() {
    return [
      Input(
        onChanged: controller.title,
        hintText: 'Nome do Item',
        currentFocusNode: titleFocus,
        nextFocusNode: descriptionFocus,
      ),
      const SizedBox(height: 16),
      Input(
        onChanged: controller.description,
        hintText: 'Descrição do Item',
        currentFocusNode: descriptionFocus,
        nextFocusNode: widthFocus,
      ),
      const SizedBox(height: 16),
      Input(
        onChanged: controller.width,
        hintText: 'Largura',
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        currentFocusNode: widthFocus,
        nextFocusNode: heightFocus,
      ),
      const SizedBox(height: 16),
      Input(
        onChanged: controller.height,
        hintText: 'Altura',
        error: controller.getError(controller.licensePlateError),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        currentFocusNode: heightFocus,
        nextFocusNode: depthFocus,
      ),
      const SizedBox(height: 16),
      Input(
        onChanged: controller.depth,
        hintText: 'Profundidade',
        error: controller.getError(controller.licensePlateError),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        currentFocusNode: depthFocus,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: '${widget.selectedType.name}',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageButton(
                    imageUrl: controller.imageFileController.value?.path,
                    imageSize: 100.0,
                    imageDataSource: ImageDataSource.asset,
                    onPressed: () async {
                      final source = await showImagePickerBottomSheet(context);

                      if (source != null) {
                        await controller.pickImage(source);

                        await Future.delayed(const Duration(milliseconds: 500));
                        if (controller.selectedItemType.value ==
                            ItemType.vehicle) {
                          showVehicleTypeBottomSheet(
                            context,
                            onItemSelected: controller.vehicleTypeController,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            Obx(
              () {
                if (controller.imageBlurhash.value != null) {
                  return Container();
                }
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Tire uma foto',
                      style: ThemeTypography.regular14.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ],
                );
              },
            ),
            ..._typeSpecificFields,
            const SizedBox(height: 16),
            Obx(
              () => FlatButton(
                actionText: controller.loading.isTrue
                    ? 'Salvando ${widget.selectedType.name}...'
                    : 'Salvar ${widget.selectedType.name}',
                onPressed: () => _saveItem(),
                // isValid: controller.isSmsValid.value,
                backgroundColor: controller.loading.isTrue
                    ? ThemeColors.secondary
                    : ThemeColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    switch (widget.selectedType.type) {
      case ItemType.vehicle:
        _saveVehicle();
        break;
      case ItemType.stock:
        _saveStock();
        break;
    }
  }

  Future<void> _saveVehicle() async {
    print('Salvei um veiculo!');
    final vehicle = await controller.createVehicle();
    Get.back(result: vehicle);
  }

  Future<void> _saveStock() async {
    print('Salvei um stock!');
    final stock = await controller.createStock();
    Get.back(result: stock);
  }
}
