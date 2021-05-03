import 'package:flutter/foundation.dart';
import 'package:va_client/models/message_properties.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
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

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return 'Message{sender: $sender, message: $message, iconTyping: $iconTyping}';
  }
}