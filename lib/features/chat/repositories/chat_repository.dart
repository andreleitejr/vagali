import 'package:vagali/features/chat/models/message.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class ChatRepository extends FirestoreRepository<Message> {
  ChatRepository(String reservationId)
      : super(
          collectionName: 'reservations/$reservationId/messages',
          fromDocument: (document) => Message.fromDocument(document),
        );
}
