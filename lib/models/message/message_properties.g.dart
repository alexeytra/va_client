// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageProperties _$MessagePropertiesFromJson(Map<String, dynamic> json) {
  return MessageProperties(
    intent: json['intent'] as String,
    accuracy: (json['accuracy'] as num)?.toDouble(),
    model: json['model'] as String,
  );
}

Map<String, dynamic> _$MessagePropertiesToJson(MessageProperties instance) =>
    <String, dynamic>{
      'intent': instance.intent,
      'accuracy': instance.accuracy,
      'model': instance.model,
    };
