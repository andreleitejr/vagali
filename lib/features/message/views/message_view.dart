import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/message/controllers/message_controller.dart';
import 'package:vagali/features/message/models/message.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class MessageView extends StatefulWidget {
  final Reservation reservation;

  const MessageView({super.key, required this.reservation});

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late MessageController controller;

  @override
  void initState() {
    controller = Get.put(MessageController(widget.reservation));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(title: 'Mensagens'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(
              () => MessageList(
                messages: controller.messages.value,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Input(
                    controller: controller.messageController,
                    hintText: 'Digite sua mensagem...',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 36,
                  width: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: ThemeColors.primary,
                      borderRadius: BorderRadius.circular(100)),
                  child: Coolicon(
                    icon: Coolicons.chatDots,
                    color: Colors.white,
                    onTap: () => controller.sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final List<Message> messages;

  MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    messages.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        return Align(
          alignment:
              message.isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isSender
                      ? ThemeColors.primary
                      : ThemeColors.grey3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.message,
                  style: ThemeTypography.regular14.apply(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                // padding: EdgeInsets.all(12),
                child: Text(
                  message.createdAt.toTimeString(),
                  style: ThemeTypography.regular14.apply(
                    color: ThemeColors.grey3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
