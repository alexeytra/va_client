import 'package:va_client/models/message_model.dart';
import 'package:va_client/utils/APIManager.dart';

Future<Message> sendQuestion(String message) async {
  var answer = <String, dynamic>{};
  var question = message.split('\s+');

  var apiManager = APIManager();
  var response = await apiManager.postAPICall('http://127.0.0.1:5000/va/api/v1/question/text',
      {'question': question.take(10).join(' ')}).then((value) {
    var statusCode = value['status'];
    if (statusCode == 200) {
      answer = value['response'];
      return Message(message: answer['answer'], sender: 'VA');
    } else if (statusCode == 500) {
      return Message(message: 'Что-то пошло не так, как я хотел 😁', sender: 'VA');
    }
  }, onError: (error) {
    print(error);
    return Future.error(Message(message: 'Нет связи с сервером 😁', sender: 'VA'));
  });

  return response;
}
