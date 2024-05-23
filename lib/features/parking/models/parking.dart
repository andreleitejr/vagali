import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/features/parking/models/price.dart';
import 'package:vagali/features/rating/models/rating.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/image_blurhash.dart';

class Parking extends BaseModel {
  final String name;
  final Price price;
  final bool isAvailable;
  final List<ParkingTag> tags;
  final String description;
  final List<ImageBlurHash> images;
  User? owner;
  final String userId;
  final String type;
  final String reservationType;

  // final OperatingHours operatingHours;
  final GeoPoint location;
  final Address address;
  final num gateHeight;
  final num gateWidth;
  final num garageDepth;
  final bool isAutomatic;
  List<Rating> ratings = <Rating>[];
  final bool isOpen;

  double distance = 0;

  Parking({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.tags,
    required this.description,
    required this.images,
    this.owner,
    required this.userId,
    required this.type,
    required this.location,
    required this.address,
    required this.gateHeight,
    required this.gateWidth,
    required this.garageDepth,
    required this.isAutomatic,
    required this.isOpen,
    required this.reservationType,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price.toMap(),
      'isAvailable': isAvailable,
      'tags': tags.map((tag) => tag.tag).toList(),
      'description': description,
      'images': images.map((image) => image.toMap()).toList(),
      'userId': userId,
      'type': type,
      // 'operatingHours': operatingHours.toMap(),
      'location': location,
      'address': address.toMap(),
      'gateHeight': gateHeight,
      'gateWidth': gateWidth,
      'garageDepth': garageDepth,
      'isAutomatic': isAutomatic,
      'isOpen': isOpen,
      'reservationType': reservationType,
      ...super.toMap(),
    };
  }

  Parking.fromDocument(DocumentSnapshot document)
      : name = document['name'],
        price = Price.fromMap(document['price']),
        isAvailable = document['isAvailable'],
        tags = (document['tags'] as List<dynamic>)
            .map((tagName) => ParkingTag(tag: tagName))
            .toList(),
        description = document['description'],
        images = (document['images'] as List<dynamic>)
            .map((imageData) => ImageBlurHash.fromMap(imageData))
            .toList(),
        userId = document['userId'],
        type = document['type'],
        // operatingHours = OperatingHours.fromMap(document['operatingHours']),
        location = document['location'],
        address = Address.fromMap(document['address']),
        gateHeight = document['gateHeight'],
        gateWidth = document['gateWidth'],
        garageDepth = document['garageDepth'],
        isOpen = document['isOpen'],
        isAutomatic = document['isAutomatic'],
        reservationType = document['reservationType'],
        super.fromDocument(document);

  Parking copyWith() {
    return Parking(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      price: price,
      isAvailable: isAvailable,
      tags: tags,
      description: description,
      images: images,
      owner: owner ?? this.owner,
      userId: userId,
      type: type,
      reservationType: reservationType,
      location: location,
      address: address,
      gateHeight: gateHeight,
      gateWidth: gateWidth,
      garageDepth: garageDepth,
      isAutomatic: isAutomatic,
      // ratings: ratings,
      isOpen: isOpen,
    );
  }
}
