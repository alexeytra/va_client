import 'package:flutter/foundation.dart';
import 'package:va_client/models/message_properties.dart';

class Message {
  final String sender;
  final String message;
  final String iconTyping;
  final MessageProperties messageProperties;

  Message({@required this.sender, this.message, this.iconTyping, this.messageProperties});

  Message copyWith({String sender, String message, String iconType}) {
    return Message(
      sender: sender ?? this.sender,
      message: message ?? this.message,
      iconTyping: message ?? this.message
    );
  }

  @override
  String toString() {
    return 'Message{sender: $sender, message: $message, iconTyping: $iconTyping}';
  }
}