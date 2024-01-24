import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/models/image_blurhash.dart';

class Vehicle extends Item {
  final String vehicleType;
  final String licensePlate;
  /// PASSAR ESSES CAMPOS PARA CAMPOS OPCIONAIS NO ITEM NO FUTURO
  final String year;
  final String color;
  final String brand;
  final String model;
  final String registrationState;

  Vehicle({
    super.id,
    required this.vehicleType,
    required this.licensePlate,
    required this.year,
    required this.color,
    required this.brand,
    required this.model,
    required this.registrationState,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.dimensions,
    required super.weight,
    required super.material,
    super.type = ItemType.vehicle,
  });

  Vehicle.fromDocument(DocumentSnapshot document)
      :
        vehicleType = document['vehicleType'],
        licensePlate = document['licensePlate'],
        year = document['year'],
        color = document['color'],
        brand = document['brand'],
        model = document['model'],
        registrationState = document['registrationState'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'image': image.toMap(),
      'vehicleType': vehicleType,
      'licensePlate': licensePlate,
      'year': year,
      'color': color,
      'brand': brand,
      'model': model,
      'registrationState': registrationState,
      ...super.toMap(),
    };
  }
}
