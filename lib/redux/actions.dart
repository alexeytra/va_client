import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/services/message_service.dart';
import 'package:va_client/utils/functions.dart';

class AddMessageAction {
  final Message addedMessage;

  AddMessageAction(this.addedMessage);
}

class ProcessTypingAction {
  final bool processTyping;

  ProcessTypingAction(this.processTyping);
}

class ChangeAreOptionsQuestionsAction {
  final bool changeAreOptionsQuestions;

  ChangeAreOptionsQuestionsAction(this.changeAreOptionsQuestions);
}

class ChangeVisibilityInputTypeAction {
  final bool visibilityInput;
  final bool visibilityFloating;

  ChangeVisibilityInputTypeAction(
      this.visibilityInput, this.visibilityFloating);
}

class ChangeListeningAction {
  final bool changeListening;

  ChangeListeningAction(this.changeListening);
}

class RemoveLastMessageAction {
  RemoveLastMessageAction();
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
      var settings = await getSettingsFromSharedPreferences();
      await sendQuestion(message, settings.voice, settings.generateAnswer).then((msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже', sender: 'VA'),
            optionalQuestions: [])));
      });
    });
    // store.dispatch(action) экшн для печатания сообщения
  };
}

ThunkAction sendWrongAnswerAction(List<Message> messages, String msg, String userId) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(SendQuestionRequestAction(msg));
      await sendWrongAnswer(messages, userId).then((response) {
        store.dispatch(SendQuestionCompletedAction(response));
        getAudioAnswer(response.audioAnswer);
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже', sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}
