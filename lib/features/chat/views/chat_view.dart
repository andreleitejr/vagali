import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/chat/controllers/chat_controller.dart';
import 'package:vagali/features/chat/models/message.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ChatView extends StatefulWidget {
  final Reservation reservation;

  const ChatView({super.key, required this.reservation});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatController controller;

  @override
  void initState() {
    controller = Get.put(ChatController(widget.reservation));
    super.initState();
  }

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(title: 'Mensagens'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];

                  return Align(
                    alignment: message.isSender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Input(
                    controller: messageController,
                    onChanged: controller.messageController,
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
                    onTap: (){
                      controller.sendMessage();
                      messageController.clear();
                    },
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
