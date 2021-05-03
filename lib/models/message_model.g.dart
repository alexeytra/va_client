// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    sender: json['sender'] as String,
    message: json['message'] as String,
    iconTyping: json['iconTyping'] as String,
    messageProperties: json['messageProperties'] == null
        ? null
        : MessageProperties.fromJson(
            json['messageProperties'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'sender': instance.sender,
      'message': instance.message,
      'iconTyping': instance.iconTyping,
      'messageProperties': instance.messageProperties,
    };
