import 'package:chat_app_ai/models/message_model.dart';
import 'package:chat_app_ai/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final chatServices = ChatServices();
  List<MessageModel> chatMessages = [];

  // Future<void> sendPrompt(String prompt) async {
  //   emit(SendingMessage());
  //   try {
  //     final response = await chatServices.sendPrompt(prompt);
  //     emit(MessageSent());
  //     emit(ChatSuccess(chatMessages));
  //   } catch (e) {
  //     emit(SendingMessageFailed(e.toString()));
  //   }
  // }

  void startChattingSession() {
    chatServices.startChattingSession();
  }

  Future<void> sendMessage(String message) async {
    emit(SendingMessage());
    try {
      chatMessages.add(MessageModel(
        text: message,
        isUser: true,
        time: DateTime.now(),
      ));
      // To update the UI with my new message before the message of the AI
      emit(ChatSuccess(chatMessages));
      final response = await chatServices.sendMessage(message);
      chatMessages.add(MessageModel(
        text: response ?? 'No response from AI',
        isUser: false,
        time: DateTime.now(),
      ));
      emit(MessageSent());
      emit(ChatSuccess(chatMessages));
    } catch (e) {
      emit(SendingMessageFailed(e.toString()));
    }
  }
}
