import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/item/models/item.dart';

class Stock extends Item {
  int productQuantity;
  String productType;

  Stock({
    required this.productQuantity,
    required this.productType,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.dimensions,
    required super.weight,
    required super.material,
    super.type = ItemType.stock,
  });

  Stock.fromDocument(DocumentSnapshot document)
      : productQuantity = document['productQuantity'],
        productType = document['productType'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'productQuantity': productQuantity,
      'productType': productType,
      ...super.toMap(),
    };
  }
}
