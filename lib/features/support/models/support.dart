import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/utils/extensions.dart';

enum SupportStatus {
  open,
  analysis,
  done,
}

class Support extends BaseModel {
  final String subject;
  final String description;
  final SupportStatus status;
  final String phone;
  final bool isWhatsApp;

  Support({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.subject,
    required this.description,
    this.status = SupportStatus.open,
    required this.phone,
    this.isWhatsApp = true,
  });

  Support.fromDocument(DocumentSnapshot document)
      : subject = document['subject'],
        description = document['description'],
        status = SupportStatusExtension.fromString(document['status']),
        phone = document['phone'],
        isWhatsApp = document['isWhatsApp'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'description': description,
      'status': status.toStringSimplified(),
      'phone': phone,
      'isWhatsApp': isWhatsApp,
      ...super.toMap(),
    };
  }
}
