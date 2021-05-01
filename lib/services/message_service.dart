import 'package:va_client/models/message_model.dart';
import 'package:va_client/utils/APIManager.dart';

Future<Message> sendQuestion(String message) async {
  Map<String, dynamic> answer = Map();
  var question = message.split("\s+");

  // viewModel
  //     .addMessage(Message(iconTyping: 'assets/typing.gif', sender: 'VA'));
  // viewModel.changeTyping(true);

  APIManager apiManager = APIManager();
  apiManager.postAPICall("http://127.0.0.1:5000/va/api/v1/question/text",
      {'question': question.take(10).join(" ")}).then((value) {
    var statusCode = value["status"];
    if (statusCode == 200) {
      answer = value["response"];
      return Message(message: answer['answer'], sender: 'VA');
      // Future.delayed(const Duration(seconds: 1), () {
      //   viewModel.changeTyping(false);
      //   viewModel.removeLastMessage();
      //   viewModel.addMessage(Message(message: answer['answer'], sender: 'VA'));
      //
      //   List<String> optQues =
      //   new List<String>.from(answer['optionalQuestions']);
      //   if (optQues.length > 0) {
      //     viewModel.clearOptionalQuestions();
      //     viewModel.addOptionalQuestions(optQues);
      //     viewModel.changeAreOptionalQuestions(true);
      //   }
      // });
      // Future.delayed(const Duration(seconds: 1), () {
      //   if (answer['audioAnswer'] != '') {
      //     _getAudioAnswer(answer['audioAnswer']);
      //   }
      // });
    } else if (statusCode == 500) {
      // viewModel.changeTyping(false);
      // viewModel.removeLastMessage();
      // viewModel.addMessage(Message(
      //     message: 'Что-то пошло не так, как я хотел 😁', sender: 'VA'));
      return Message(message: 'Что-то пошло не так, как я хотел 😁', sender: 'VA');
    }
  }, onError: (error) {
    print(error);
    // viewModel.changeTyping(false);
    // viewModel.removeLastMessage();
    // viewModel.addMessage(
    //     Message(message: 'Нет связи с сервером 😁', sender: 'VA'));
    return Future.error(Message(message: 'Нет связи с сервером 😁', sender: 'VA'));
  });
}
