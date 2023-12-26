import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/rating/models/rating.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/models/coordinates.dart';
import 'package:vagali/models/image_blurhash.dart';

class UserType {
  static const tenant = 'tenant';
  static const landlord = 'landlord';
}

class User extends BaseModel {
  final ImageBlurHash image;
  final String email;
  final String document;
  final String firstName;
  final String lastName;
  final String phone;
  final DateTime birthday;
  final Address address;
  final String type;
  Rating? rating;

  User({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.email,
    required this.image,
    required this.document,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthday,
    required this.address,
    required this.type,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  User.fromDocument(DocumentSnapshot document)
      : image = ImageBlurHash.fromMap(document['image']),
        email = document['email'],
        document = document['document'],
        firstName = document['firstName'],
        lastName = document['lastName'],
        phone = document['phone'],
        birthday = (document['birthday'] as Timestamp).toDate(),
        address = Address.fromMap(document['address']),
        type = document['type'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'image': image.toMap(),
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'birthday': birthday.toUtc(),
      'address': address.toMap(),
      'type': type,
      ...super.toMap(),
    };
  }

  bool get isTenant => type == UserType.tenant;

  bool get isLandlord => type == UserType.landlord;
}
