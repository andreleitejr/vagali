import 'package:get/get.dart';
import 'package:vagali/apps/landlord/models/landlord.dart';
import 'package:vagali/features/chat/models/message.dart';
import 'package:vagali/features/chat/repositories/chat_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class ChatController extends GetxController {
  ChatController(this.reservation) {
    _repository = Get.put(ChatRepository(reservation.id!));
  }

  final User user = Get.find();
  final messages = <Message>[].obs;
  final Reservation reservation;

  late ChatRepository _repository;

  final messageController = ''.obs;

  void streamMessages() {
    _repository.streamAll().listen((dataList) {
      messages.assignAll(dataList);
    });
  }

  Future<void> sendMessage() async {
    if (messageController.value.isNotEmpty) {
      final newMessage = Message(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        to: user is Landlord ? reservation.tenantId : reservation.landlordId,
        from: user.id!,
        message: messageController.value,
      );

      final result = await _repository.save(newMessage);

      if (result == SaveResult.success) {
        // messages.add(newMessage);
        messageController.value = '';
      }
    }
  }

  @override
  void onInit() {
    streamMessages();
    super.onInit();
  }
}
