import 'package:vagali/features/rating/models/rating.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class RatingRepository extends FirestoreRepository<Rating> {
  RatingRepository(String parentCollection, String parentId)
      : super(
          collectionName: '$parentCollection/$parentId/ratings',
          fromDocument: (document) => Rating.fromDocument(document),
        );
}
