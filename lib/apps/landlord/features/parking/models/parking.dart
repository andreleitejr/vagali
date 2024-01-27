import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_tag.dart';
import 'package:vagali/apps/landlord/features/parking/models/price.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/rating/models/rating.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/services/location_service.dart';

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

  final LocationService _locationService = Get.put(LocationService());

  double get distance {
    /// APENAS PARA TESTES
    ///
    final userCoordinates = _locationService.userLocation;

    if (userCoordinates == null) {
      return 0.0;
    }

    return Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      userCoordinates.latitude,
      userCoordinates.longitude,
    );
  }

  Parking({
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.tags,
    required this.description,
    required this.images,
    required this.userId,
    required this.type,
    // required this.operatingHours,
    required this.location,
    required this.address,
    required this.gateHeight,
    required this.gateWidth,
    required this.garageDepth,
    required this.isAutomatic,
    required this.isOpen,
    required this.reservationType,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price.toMap(),
      'isAvailable': isAvailable,
      'tags': tags.map((tag) => tag.name).toList(),
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
}
