import 'package:get/get.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/features/parking/repositories/parking_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/reservation/repositories/reservation_repository.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/vehicle/models/vehicle.dart';
import 'package:vagali/features/vehicle/repositories/vehicle_repository.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class UserRepository extends FirestoreRepository<User> {
  UserRepository()
      : super(
          collectionName: 'users',
          fromDocument: (document) => User.fromDocument(document),
        );

  @override
  Future<User?> get(String documentId) async {
    print(' HAUHASUHSADUASHDUADHSDDASHUDASHDASUHDASUHASDU JESUS $collectionName');
    try {

      final document =
          await firestore.collection(collectionName).doc(documentId).get();
 print('DAFDDHSSAUHSAA FIRESTORE DOCUMENT ${collectionName} $document');
      final user = fromDocument(document);

      if (user.type == UserType.tenant) {
        return Tenant.fromDocument(document);
      } else if (user.type == UserType.landlord) {
        return Landlord.fromDocument(document);
      } else {
        return user;
      }
    } catch (error) {
      print('Error fetching data from Firestore: $error');
      return null;
    }
  }
}
