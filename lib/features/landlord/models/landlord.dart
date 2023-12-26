import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/coordinates.dart';
import 'package:vagali/models/image_blurhash.dart';

// Futuros dados de Landlord
// Dados Bancários: Informações bancárias para receber pagamentos de aluguéis.
//
// Histórico Financeiro: Registros financeiros relacionados aos aluguéis e despesas

class Landlord extends User {
  final parkings = <Parking>[];

  Landlord({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String email,
    required ImageBlurHash image,
    required String document,
    required String firstName,
    required String lastName,
    required String phone,
    required DateTime birthday,
    required Address address,
    required String type,
    // required GeoPoint coordinates,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          email: email,
          image: image,
          document: document,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          birthday: birthday,
          address: address,
          type: type,
        );

  Landlord.fromDocument(DocumentSnapshot document)
      : super.fromDocument(document);

  factory Landlord.fromUser(User user) {
    return Landlord(
      id: user.id!,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      email: user.email,
      image: user.image!,
      document: user.document,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      birthday: user.birthday,
      address: user.address,
      type: user.type,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final userMap = super.toMap();
    userMap['parkings'] = parkings.map((parking) => parking.toMap()).toList();
    return userMap;
  }
}
