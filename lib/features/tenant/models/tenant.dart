import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/models/coordinates.dart';
import 'package:vagali/models/image_blurhash.dart';

// Futuros dados de Tenant
// Garagem Alugada: Informações sobre a garagem que o Tenant alugou, incluindo o endereço, preço de aluguel, data de início e término do contrato, etc.
//
// Histórico de Pagamentos: Registro de pagamentos de aluguéis anteriores e atuais.
//
// Documentação de Contrato: Contrato de locação da garagem e outros documentos relacionados.
//
// Avaliações: Avaliações e comentários sobre a garagem e a experiência de aluguel.

class Tenant extends User {
  final vehicles = <Vehicle>[];

  Tenant({
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

  Tenant.fromDocument(DocumentSnapshot document) : super.fromDocument(document);

  factory Tenant.fromUser(User user) {
    return Tenant(
      id: user.id!,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      email: user.email,
      image: user.image,
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
    return userMap;
  }
}
