import 'package:vagali/features/cashout/models/cashout.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class CashOutRepository extends FirestoreRepository<CashOut> {
  CashOutRepository()
      : super(
    collectionName: 'cashouts',
    fromDocument: (document) => CashOut.fromDocument(document),
  );
}
