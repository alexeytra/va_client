import 'package:flutter/foundation.dart';

class Message {
  final String sender;
  final String message;
  final String iconTyping;

  Message({@required this.sender, @required this.message, this.iconTyping});

  Message copyWith({String sender, String message, String iconType}) {
    return Message(
      sender: sender ?? this.sender,
      message: message ?? this.message,
      iconTyping: message ?? this.message
    );
  }
}