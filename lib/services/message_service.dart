import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/utils/APIManager.dart';

Future<MessageResponse> sendQuestion(String message) async {
  var question = message.split('\s+');
  var apiManager = APIManager();
  var response = await apiManager
      .sendQuestionApi({'question': question.take(10).join(' ')}).then((value) {
    var statusCode = value['status'];
    if (statusCode == 200) {
      var answer = value['response'];
      var optionalQuestions = List<String>.from(answer['optionalQuestions']);
      return MessageResponse(
          message: Message(message: answer['answer'], sender: 'VA'),
          optionalQuestions: optionalQuestions, audioAnswer: answer['audioAnswer']);
    } else if (statusCode == 500) {
      return MessageResponse(
          message: Message(
              message: 'Что-то пошло не так, как я хотел 😁', sender: 'VA'),
          optionalQuestions: []);
    }
  }, onError: (error) {
    print(error);
    return Future.error(MessageResponse(
        message: Message(message: 'Нет связи с сервером 😁', sender: 'VA'),
        optionalQuestions: []));
  });

  return response;
}