import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/services/message_service.dart';
import 'package:va_client/utils/functions.dart';

// add
class AddMessageAction {
  final Message addedMessage;

  AddMessageAction(this.addedMessage);
}

// add
class ProcessTypingAction {
  final bool processTyping;

  ProcessTypingAction(this.processTyping);
}

//add
class ChangeAreOptionsQuestionsAction {
  final bool changeAreOptionsQuestions;

  ChangeAreOptionsQuestionsAction(this.changeAreOptionsQuestions);
}

class ChangeVisibilityInputAction {
  final bool changeVisibilityInput;

  ChangeVisibilityInputAction(this.changeVisibilityInput);
}

class ChangeVisibilityFloatingAction {
  final bool changeVisibilityFloating;

  ChangeVisibilityFloatingAction(this.changeVisibilityFloating);
}

class ChangeListeningAction {
  final bool changeListening;

  ChangeListeningAction(this.changeListening);
}

class RemoveLastMessageAction {
  RemoveLastMessageAction();
}

class ClearOptionalQuestionsAction {
  ClearOptionalQuestionsAction();
}

class AddOptionalQuestionsAction {
  final List<String> areOptionalQuestions;

  AddOptionalQuestionsAction(this.areOptionalQuestions);
}

class ChangeAreOptionalQuestionsAction {
  final bool changeAreOptionalQuestions;

  ChangeAreOptionalQuestionsAction(this.changeAreOptionalQuestions);
}

class SendQuestionRequestAction {
  String message;

  SendQuestionRequestAction(this.message);
}

class SendQuestionCompletedAction {
  final MessageResponse msgRes;

  SendQuestionCompletedAction(this.msgRes);
}

ThunkAction sendQuestionAction(String message) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(SendQuestionRequestAction(message));
      await sendQuestion(message).then((msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
      }, onError: (error) => store.dispatch(AddMessageAction(Message(message: 'Что-то пошло не так 😁', sender: 'VA'))));
    });
    // store.dispatch(action) экшн для печатания сообщения
  };
}
