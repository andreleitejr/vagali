import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class ItemRepository extends FirestoreRepository<Item> {
  ItemRepository()
      : super(
          collectionName: 'items',
          fromDocument: (document) => Item.fromDocument(document),
        );
}
