class MessageModel {
  final String text;
  final bool isUser;
  final DateTime time;

  const MessageModel({
    required this.text,
    required this.isUser,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'text': text});
    result.addAll({'isUser': isUser});
    result.addAll({'time': time.millisecondsSinceEpoch});
  
    return result;
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  MessageModel copyWith({
    String? text,
    bool? isUser,
    DateTime? time,
  }) {
    return MessageModel(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      time: time ?? this.time,
    );
  }
}
