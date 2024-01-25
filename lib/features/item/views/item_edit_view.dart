import 'package:flutter/material.dart';
import 'package:vagali/features/item/models/item.dart';

class ItemEditView extends StatefulWidget {
  final ItemType selectedType;

  ItemEditView({required this.selectedType});

  @override
  _ItemEditViewState createState() => _ItemEditViewState();
}

class _ItemEditViewState extends State<ItemEditView> {
  final TextEditingController _commonFieldController = TextEditingController();
  late List<Widget> _typeSpecificFields;

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
      TextFormField(
        decoration: InputDecoration(labelText: 'Vehicle-Specific Field 1'),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Vehicle-Specific Field 2'),
      ),
      // Add more vehicle-specific fields as needed
    ];
  }

  List<Widget> _buildStockFields() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Stock-Specific Field 1'),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Stock-Specific Field 2'),
      ),
      // Add more stock-specific fields as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create ${widget.selectedType.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _commonFieldController,
              decoration: InputDecoration(labelText: 'Common Field'),
            ),
            // Add more common fields as needed
            ..._typeSpecificFields,
            ElevatedButton(
              onPressed: () {
                // Save the item with the entered data
                _saveItem();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveItem() {
    // Depending on the selected type, handle saving logic
    switch (widget.selectedType.type) {
      case ItemType.vehicle:
        _saveVehicle();
        break;
      case ItemType.stock:
        _saveStock();
        break;
    }
  }

  void _saveVehicle() {
    // Implement saving logic for Vehicle type
  }

  void _saveStock() {
    // Implement saving logic for Stock type
  }
}
