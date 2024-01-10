import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/message/models/message.dart';
import 'package:vagali/features/message/repositories/message_repository.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class MessageController extends GetxController {
  MessageController(this.reservation) {
    _repository = Get.put(MessageRepository(reservation.id!));
  }
  final User user = Get.find();
  final messages = <Message>[].obs;
  final Reservation reservation;

  late MessageRepository _repository;

  final messageController = TextEditingController();

  void streamMessages() {
    _repository.streamAll().listen((dataList) {
      messages.assignAll(dataList);
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      final newMessage = Message(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        to: user is Landlord ? reservation.tenantId : reservation.landlordId,
        from: user.id!,
        message: messageController.text,
      );

      final result = await _repository.save(newMessage);

      if (result == SaveResult.success) {
        // messages.add(newMessage);
        messageController.clear();
      }
    }
  }


  @override
  void onInit() {
    streamMessages();
    super.onInit();
  }
}
