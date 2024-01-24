import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/models/dimension.dart';
import 'package:vagali/models/base_model.dart';

enum ItemType { vehicle, stock }

class Item extends BaseModel {
  final Dimension dimensions;
  final double weight;
  final ItemType type;
  final String material;

  Item({
    super.id,
    required this.weight,
    required this.type,
    required this.material,
    required this.dimensions,
    required super.createdAt,
    required super.updatedAt,
  });

  Item.fromDocument(DocumentSnapshot document)
      : dimensions = Dimension.fromMap(document['image']),
        weight = document['weight'],
        type = document['type'],
        material = document['material'],
        super.fromDocument(document);
}
