import 'package:vagali/features/support/models/support.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class SupportRepository extends FirestoreRepository<Support> {
  SupportRepository()
      : super(
          collectionName: 'supports',
          fromDocument: (document) => Support.fromDocument(document),
        );
}
