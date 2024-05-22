import 'package:cloud_firestore/cloud_firestore.dart';

class BaseModel {
  String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toUtc(),
      'updatedAt': DateTime.now(),
    };
  }

  BaseModel.fromDocument(DocumentSnapshot document)
      : id = document.id,
        createdAt = (document['createdAt'] as Timestamp).toDate(),
        updatedAt = (document['updatedAt'] as Timestamp).toDate();
}
