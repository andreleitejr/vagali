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
            .map(
              (tagName) => parkingTags.firstWhere((tag) => tag.tag == tagName),
            )
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

  Parking copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    Price? price,
    bool? isAvailable,
    List<ParkingTag>? tags,
    String? description,
    List<ImageBlurHash>? images,
    User? owner,
    String? userId,
    String? type,
    String? reservationType,
    GeoPoint? location,
    Address? address,
    num? gateHeight,
    num? gateWidth,
    num? garageDepth,
    bool? isAutomatic,
    List<Rating>? ratings,
    bool? isOpen,
    double? distance,
  }) {
    return Parking(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      images: images ?? this.images,
      owner: owner ?? this.owner,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      reservationType: reservationType ?? this.reservationType,
      location: location ?? this.location,
      address: address ?? this.address,
      gateHeight: gateHeight ?? this.gateHeight,
      gateWidth: gateWidth ?? this.gateWidth,
      garageDepth: garageDepth ?? this.garageDepth,
      isAutomatic: isAutomatic ?? this.isAutomatic,
      isOpen: isOpen ?? this.isOpen,
    )..ratings = ratings ?? this.ratings;
  }
}
