// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vagali/models/base_model.dart';
// import 'package:vagali/models/image_blurhash.dart';
//
// class Vehicle extends BaseModel {
//   final ImageBlurHash image;
//   final String vehicleType;
//   final String licensePlate;
//   final String year;
//   final String color;
//   final String brand;
//   final String model;
//   final String registrationState;
//
//   Vehicle({
//     required this.image,
//     required DateTime createdAt,
//     required DateTime updatedAt,
//     required this.vehicleType,
//     required this.licensePlate,
//     required this.year,
//     required this.color,
//     required this.brand,
//     required this.model,
//     required this.registrationState,
//   }) : super(
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//         );
//
//   Vehicle.fromDocument(DocumentSnapshot document)
//       : image = ImageBlurHash.fromMap(document['image']),
//         vehicleType = document['vehicleType'],
//         licensePlate = document['licensePlate'],
//         year = document['year'],
//         color = document['color'],
//         brand = document['brand'],
//         model = document['model'],
//         registrationState = document['registrationState'],
//         super.fromDocument(document);
//
//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       'image': image.toMap(),
//       'vehicleType': vehicleType,
//       'licensePlate': licensePlate,
//       'year': year,
//       'color': color,
//       'brand': brand,
//       'model': model,
//       'registrationState': registrationState,
//       ...super.toMap(),
//     };
//   }
// }
