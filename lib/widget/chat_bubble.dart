import 'package:flutter/material.dart';
import 'package:recipe_ai/utils/colors.dart';

class ChatBubble extends StatelessWidget {
  final String textOutput;
  final String time;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.textOutput,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: FractionallySizedBox(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? ColorsUtil.userChatBackgroundColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: !isMe ? Radius.circular(20) : Radius.circular(0),
              bottomLeft: isMe ? Radius.circular(20) : Radius.circular(0),
            ),
          ),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              textOutput,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 14),
            ),
            subtitle: Text(
              '$time AM',
            ),
          ),
        ),
      ),
    );
  }
}