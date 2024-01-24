import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/dimension.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/coolicons.dart';

class Item extends BaseModel {
  final ImageBlurHash image;
  final Dimension dimensions;
  final double weight;
  final String type;
  final String material;

  Item({
    super.id,
    required this.image,
    required this.weight,
    required this.type,
    required this.material,
    required this.dimensions,
    required super.createdAt,
    required super.updatedAt,
  });

  Item.fromDocument(DocumentSnapshot document)
      : image = ImageBlurHash.fromMap(document['image']),
        dimensions = Dimension.fromMap(document['dimensions']),
        weight = document['weight'],
        type = document['type'],
        material = document['material'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'image': image.toMap(),
      'dimensions': dimensions.toMap(),
      'weight': weight,
      'type': type.toString(),
      'material': material,
      ...super.toMap(),
    };
  }
}

class ItemType extends SelectableItem {
  final String? name;
  final String? description;
  final String type;
  late final String icon;

  ItemType({
    required this.type,
    this.name,
    this.description,
    this.icon = Coolicons.house,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }

  static ItemType fromMap(Map<String, dynamic> map) {
    return ItemType(
      type: map['type'],
    );
  }

  @override
  String get title => type;

  static const vehicle = 'vehicle';
  static const stock = 'stock';
}

final itemTypes = <ItemType>[
  ItemType(
    type: ItemType.vehicle,
    name: 'Veiculos',
    description: 'Veiculos description',
    icon: Coolicons.car,
  ),
  ItemType(
    type: ItemType.stock,
    name: 'Estoques',
    description: 'Estoques description',
    icon: Coolicons.car,
  ),
];
