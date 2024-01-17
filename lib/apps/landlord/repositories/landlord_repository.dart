import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/repositories/parking_repository.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class LandlordRepository extends FirestoreRepository<Landlord> {
  LandlordRepository()
      : super(
          collectionName: 'users',
          fromDocument: (document) => Landlord.fromDocument(document),
        );
}
