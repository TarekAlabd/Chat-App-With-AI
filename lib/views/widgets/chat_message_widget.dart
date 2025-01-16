import 'package:chat_app_ai/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: size.width - 100,
        child: Row(
          children: [
            if (message.isUser) ...[
              CircleAvatar(
                radius: 16.0,
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 8.0),
            ],
            Expanded(
              child: Card(
                color: message.isUser ? Colors.blue : null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: message.isUser ? Colors.white : null,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
