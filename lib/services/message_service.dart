import 'package:va_client/models/user/login_response.dart';
import 'package:va_client/models/message/message_model.dart';
import 'package:va_client/models/message/message_response.dart';
import 'package:va_client/utils/api_manager.dart';
import 'package:va_client/utils/functions.dart';

Future<MessageResponse> sendQuestion(
    String message, bool voice, bool generateAnswer, LoginResponse user) async {
  var question = message.split('\s+');
  var response = await APIManager.sendQuestionApi({
    'question': question.take(10).join(' '),
    'voice': voice,
    'generateAnswer': generateAnswer,
    'user_id': user?.userId ?? '',
    'user_token': user?.accessToken ?? '',
    'user_type': user?.userType ?? ''
  }).then((value) {
    return getMessageResponseObject(value['status'], value['response']);
  }, onError: (error) {
    return Future.error(error);
  });

  return response;
}

Future<MessageResponse> sendWrongAnswer(
    List<Message> messages, String userId, bool voice) async {
  var response = await APIManager.sendWrongAnswerApi(
      {'messages': messages, 'userId': userId, 'voice': voice}).then((value) {
    return getMessageResponseObject(value['status'], value['response']);
  }, onError: (e) {
    return Future.error(e);
  });

  return response;
}


