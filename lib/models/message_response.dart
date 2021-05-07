import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_properties.dart';

class MessageResponse {
  final Message message;
  final List<String> optionalQuestions;
  final String audioAnswer;
  final String additionalResponse;

  MessageResponse(
      {this.message,
      this.optionalQuestions,
      this.audioAnswer = '',
      this.additionalResponse});

  MessageResponse.fromJson(Map<String, dynamic> json)
      : message = Message(
            message: json['answer'],
            sender: 'VA',
            messageProperties: MessageProperties(
                intent: json['intent'],
                accuracy: json['accuracy'],
                model: json['model'])),
        optionalQuestions = List<String>.from(json['optionalQuestions']),
        audioAnswer = json['audioAnswer'],
        additionalResponse = json['additionalResponse'];

  @override
  String toString() {
    return 'MessageResponse{message: $message, optionalQuestions: $optionalQuestions, audioAnswer: $audioAnswer}';
  }
}
