import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/models/base_model.dart';
import 'package:vagali/utils/extensions.dart';

enum CashOutStatus { pending, approved, paid, rejected }

class CashOut extends BaseModel {
  final String userId;
  final double amount;
  final CashOutStatus status;

  CashOut({
    super.id,
    required this.userId,
    required this.amount,
    required this.status,
    required super.createdAt,
    required super.updatedAt,
  });

  CashOut.fromDocument(DocumentSnapshot document)
      : userId = document['userId'],
        amount = document['amount'],
        status = CashOutStatusExtension.fromString(document['status']),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'status': status.toStringSimplified(),
      ...super.toMap(),
    };
  }
}
