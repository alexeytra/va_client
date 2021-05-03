import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/utils/APIManager.dart';
// TODO: убрать повтор после статуса
Future<MessageResponse> sendQuestion(String message) async {
  var question = message.split('\s+');
  var response = await APIManager.sendQuestionApi(
      {'question': question.take(10).join(' ')}).then((value) {
    var statusCode = value['status'];
    if (statusCode == 200) {
      return MessageResponse.fromJson(value['response']);
    } else if (statusCode == 500) {
      return MessageResponse(
          message: Message(
              message: 'Что-то пошло не так 😁 Попробуйте позже', sender: 'VA'),
          optionalQuestions: []);
    }
  }, onError: (error) {
    return Future.error(MessageResponse(
        message: Message(message: 'Нет связи с сервером 😁', sender: 'VA'),
        optionalQuestions: []));
  });

  return response;
}

Future<MessageResponse> sendWrongAnswer(List<Message> messages, String userId) async {
  var response =  await APIManager.sendWrongAnswer({'messages': messages, 'userId': userId}).then((value) {
    var statusCode = value['status'];
    if (statusCode == 200) {
      return MessageResponse.fromJson(value['response']);
    } else if (statusCode == 500) {
      return MessageResponse(
          message: Message(
              message: 'Что-то пошло не так 😁 Попробуйте позже', sender: 'VA'),
          optionalQuestions: []);
    }
  }, onError: (e) {
    return Future.error(MessageResponse(
        message: Message(message: 'Нет связи с сервером 😁', sender: 'VA'),
        optionalQuestions: []));
  });

  return response;
}
