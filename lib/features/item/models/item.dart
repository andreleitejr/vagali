import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/dimension.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/images.dart';

class Item extends BaseModel {
  final String? title;
  final String? description;
  final ImageBlurHash image;
  final Dimension dimensions;
  final double weight;
  final String type;
  final String material;

  Item({
    super.id,
    this.title,
    this.description,
    required this.image,
    required this.weight,
    required this.type,
    required this.material,
    required this.dimensions,
    required super.createdAt,
    required super.updatedAt,
  });

  Item.fromDocument(DocumentSnapshot document)
      : title = document['title'],
        description = document['description'],
        image = ImageBlurHash.fromMap(document['image']),
        dimensions = Dimension.fromMap(document['dimensions']),
        weight = document['weight'],
        type = document['type'],
        material = document['material'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
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
  late final String image;

  ItemType({
    required this.type,
    this.name,
    this.description,
    this.image = Coolicons.house,
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
  static const furniture = 'furniture';
  static const homeAppliance = 'homeAppliance';
  static const householdHardware = 'householdHardware';
  static const shopping = 'shopping';
  static const other = 'other';
}

final itemTypes = <ItemType>[
  ItemType(
    type: ItemType.vehicle,
    name: 'Veículo',
    description: 'Carros, vans, pickups, caminhões, etc.',
    image: Images.carItem,
  ),
  ItemType(
    type: ItemType.stock,
    name: 'Estoque',
    description: 'Produtos, materiais, caixas, etc.',
    image: Images.stock,
  ),
  ItemType(
    type: ItemType.furniture,
    name: 'Móveis',
    description: 'Guarda-roupas, sofás, camas, etc.',
    image: Images.furniture,
  ),
  ItemType(
    type: ItemType.homeAppliance,
    name: 'Eletrodomésticos',
    description: 'Geladeiras, fogões, máquinas de lavar, etc.',
    image: Images.homeAppliance,
  ),
  ItemType(
    type: ItemType.householdHardware,
    name: 'Materiais de Construção',
    description: 'Ferramentas, sacos de cimento, areia, etc.',
    image: Images.householdHardware,
  ),
  ItemType(
    type: ItemType.shopping,
    name: 'Compras',
    description: 'Mercado, delivery, internacionais, etc.',
    image: Images.shopping,
  ),
  ItemType(
    type: ItemType.other,
    name: 'Outros',
    description: 'Outros description',
    image: Images.other,
  ),
];
