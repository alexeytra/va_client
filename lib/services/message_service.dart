import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/utils/api_manager.dart';
import 'package:va_client/utils/functions.dart';

Future<MessageResponse> sendQuestion(String message, bool voice, bool generateAnswer) async {
  var question = message.split('\s+');
  var response = await APIManager.sendQuestionApi(
      {'question': question.take(10).join(' '), 'voice': voice, 'generateAnswer': generateAnswer}).then((value) {
    return getResponseObject(value['status'], value['response']);
  }, onError: (error) {
    return Future.error(error);
  });

  return response;
}

Future<MessageResponse> sendWrongAnswer(List<Message> messages, String userId) async {
  var response =  await APIManager.sendWrongAnswer({'messages': messages, 'userId': userId}).then((value) {
    return getResponseObject(value['status'], value['response']);
  }, onError: (e) {
    return Future.error(e);
  });

  return response;
}
