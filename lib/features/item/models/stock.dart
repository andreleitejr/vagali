import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/item/models/item.dart';

class Stock extends Item {
  int productQuantity;
  String productType;

  Stock({
    required this.productQuantity,
    required this.productType,
    required super.id,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.dimensions,
    required super.weight,
    required super.material,
    required super.userId,
    super.type = ItemType.stock,
    required super.title,
    required super.description,
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
