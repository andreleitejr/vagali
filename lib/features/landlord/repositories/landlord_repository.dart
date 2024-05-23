import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class LandlordRepository extends FirestoreRepository<Landlord> {
  LandlordRepository()
      : super(
          collectionName: 'landlords',
          fromDocument: (document) => Landlord.fromDocument(document),
        );
}
