import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/base_model.dart';

class Message extends BaseModel {
  // final String reservationId;
  final String from;
  final String to;
  final String message;

  Message({
    required DateTime createdAt,
    required DateTime updatedAt,
    // required this.reservationId,
    required this.from,
    required this.to,
    required this.message,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  Message.fromDocument(DocumentSnapshot document)
      : /*reservationId = document['reservationId'],*/
        from = document['from'],
        to = document['to'],
        message = document['message'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      // 'reservationId': reservationId,
      'from': from,
      'to': to,
      'message': message,
      ...super.toMap(),
    };
  }

  final User user = Get.find();

  bool get isSender {
    return user.id == from;
  }
}
