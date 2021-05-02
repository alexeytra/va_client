import 'package:va_client/models/message_model.dart';

class MessageResponse {
  final Message message;
  final List<String> optionalQuestions;
  final String audioAnswer;

  MessageResponse({this.message, this.optionalQuestions, this.audioAnswer = ''});
}