import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/models/base_model.dart';

class Message extends BaseModel {
  final String from;
  final String to;
  final String message;

  Message({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.from,
    required this.to,
    required this.message,
  });

  Message.fromDocument(DocumentSnapshot document)
      : from = document['from'],
        to = document['to'],
        message = document['message'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
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
