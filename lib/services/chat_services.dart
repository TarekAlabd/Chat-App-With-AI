import 'dart:io';

import 'package:chat_app_ai/utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatServices {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: AppConstants.apiKey,
  );

  late ChatSession _chatSession;

  Future<String?> sendPrompt(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response.text;
  }

  void startChattingSession() {
    _chatSession = model.startChat();
  }

  Future<String?> sendMessage(String message, [File? image]) async {
    late final Content content;
    if (image != null) {
      final bytes = await image.readAsBytes();
      content = Content.multi(
        [
          TextPart(message),
          DataPart('image/jpeg', bytes),
        ],
      );
    } else {
      content = Content.text(message);
    }
    final response = await _chatSession.sendMessage(content);

    return response.text;
  }
}
