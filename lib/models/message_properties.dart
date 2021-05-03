import 'package:json_annotation/json_annotation.dart';
part 'message_properties.g.dart';

@JsonSerializable()
class MessageProperties {
  final String intent;
  final double accuracy;
  final String model;

  MessageProperties({this.intent, this.accuracy, this.model});

  factory MessageProperties.fromJson(Map<String, dynamic> json) =>
      _$MessagePropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$MessagePropertiesToJson(this);

}