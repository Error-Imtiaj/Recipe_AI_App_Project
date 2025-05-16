import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_ai/screens/controllers/chatpage_controller.dart';
import 'package:recipe_ai/utils/colors.dart';
import 'package:recipe_ai/widget/chat_bubble.dart';
import 'package:recipe_ai/widget/r_app_bar.dart';

class ChatPage extends StatelessWidget {
  static const String routename = '/chatPage';
  final ChatController _controller = Get.put(ChatController());

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.appBackgroundColor,
      appBar: RappBar(
        onClearChat: _controller.clearChat,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Gap(5),
            _chatMessagesSection(),
            const Gap(10),
            Divider(
              color: ColorsUtil.deviderColor,
            ),
            _bottomSection(),
          ],
        ),
      ),
    );
  }

  // Chat message section
  Widget _chatMessagesSection() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _controller.userBox.listenable(),
        builder: (context, Box box, _) {
          final messages =
              box.values.toList().reversed.toList(); // Show latest at bottom

          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              return ChatBubble(
                textOutput: message['user'].toString(),
                time: message['time'].toString(),
                isMe: message['isMe'] ?? true,
              );
            },
          );
        },
      ),
    );
  }

  // Bottom section with input and send button
  Widget _bottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 24, top: 5),
      child: Row(
        children: [
          Expanded(
            child: _inputField(),
          ),
          const Gap(10),
          _sendButton(),
        ],
      ),
    );
  }

  // Input text field
  Widget _inputField() {
    return TextFormField(
      controller: _controller.textController,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintText: "Only Recipe Name",
        hintStyle: TextStyle(color: ColorsUtil.inputTextColor),
        fillColor: ColorsUtil.inputFiledBackgroudColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      autofocus: true,
      textInputAction: TextInputAction.send,
      onFieldSubmitted: (value) {
        if (_controller.textController.text.isNotEmpty) {
          _controller.addMessage(_controller.textController.text);
          _controller.textController.clear();
        }
      },
    );
  }

  // Send button
  Widget _sendButton() {
    return IconButton.filledTonal(
        style: IconButton.styleFrom(
            backgroundColor: ColorsUtil.buttonBackgroundColor),
        padding: EdgeInsets.all(16),
        onPressed: () {
          if (_controller.textController.text.trim().isNotEmpty) {
            _controller.addMessage(_controller.textController.text);
            _controller.textController.clear();
          }
        },
        icon: Icon(
          Iconsax.send_2,
          color: ColorsUtil.appbarBackgroundColor,
        ));
  }
}
