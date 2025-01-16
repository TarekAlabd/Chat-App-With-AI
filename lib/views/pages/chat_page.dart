import 'package:chat_app_ai/cubit/chat_cubit.dart';
import 'package:chat_app_ai/views/widgets/chat_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatCubit>(context).startChattingSession();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      ),
    );
  }

  void showOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<ChatCubit>(context).pickImageFromCamera();
              },
              child: const Text('Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<ChatCubit>(context).pickImageFromGallery();
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  bloc: chatCubit,
                  buildWhen: (previous, current) => current is ChatSuccess,
                  builder: (context, state) {
                    if (state is ChatSuccess) {
                      final messages = state.messages;
                      return ListView.separated(
                        controller: _scrollController,
                        itemCount: messages.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8.0),
                        itemBuilder: (_, index) {
                          final message = messages[index];
                          return ChatMessageWidget(message: message);
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ChatCubit, ChatState>(
                    bloc: chatCubit,
                    buildWhen: (previous, current) =>
                        current is ImagePicked || current is ImageRemoved,
                    builder: (_, state) {
                      if (state is ImagePicked) {
                        return SizedBox(
                          height: 200.0,
                          width: size.width - 75,
                          child: Card(
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.file(
                                      state.image,
                                      width: size.width - 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: () => chatCubit.removeImage(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            suffix: InkWell(
                              child: const Icon(Icons.attachment),
                              onTap: () {
                                showOptions();
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            chatCubit.sendMessage(value);
                            _messageController.clear();
                            chatCubit.removeImage();
                            _scrollDown();
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      BlocConsumer<ChatCubit, ChatState>(
                        bloc: chatCubit,
                        listenWhen: (previous, current) =>
                            current is SendingMessageFailed ||
                            current is ChatSuccess,
                        listener: (context, state) {
                          if (state is SendingMessageFailed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                              ),
                            );
                          } else if (state is ChatSuccess) {
                            _scrollDown();
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is MessageSent ||
                            current is SendingMessage ||
                            current is SendingMessageFailed,
                        builder: (context, state) {
                          if (state is SendingMessage) {
                            return const CircularProgressIndicator.adaptive();
                          }
                          return IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              chatCubit.sendMessage(_messageController.text);
                              _messageController.clear();
                              chatCubit.removeImage();
                              _scrollDown();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
