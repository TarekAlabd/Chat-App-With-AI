import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app_ai/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formattedTime = DateFormat('hh:mm a').format(message.time);
    final textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: message.isUser ? Colors.white : null,
          fontWeight: FontWeight.normal,
        );

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Card(
                    color: message.isUser ? Colors.blue : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: message.isUser
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message.image != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.file(
                                      message.image!,
                                      height: 175,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                const SizedBox(height: 8.0),
                                Text(
                                  message.text,
                                  style: textStyle,
                                ),
                              ],
                            )
                          : AnimatedTextKit(
                              repeatForever: false,
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText(
                                  message.text,
                                  textStyle: textStyle,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(formattedTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
