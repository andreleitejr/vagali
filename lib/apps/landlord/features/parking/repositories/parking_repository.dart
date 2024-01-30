
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class ParkingRepository extends FirestoreRepository<Parking> {
  ParkingRepository()
      : super(
          collectionName: 'parkings',
          fromDocument: (document) => Parking.fromDocument(document),
        );
}
