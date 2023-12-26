import 'package:vagali/features/message/models/message.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class MessageRepository extends FirestoreRepository<Message> {
  MessageRepository(String reservationId)
      : super(
          collectionName: 'reservations/$reservationId/messages',
          fromDocument: (document) => Message.fromDocument(document),
        );
}
