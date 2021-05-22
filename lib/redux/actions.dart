import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:va_client/models/login_response.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/models/navigation.dart';
import 'package:va_client/services/message_service.dart';
import 'package:va_client/services/user_service.dart';
import 'package:va_client/utils/functions.dart';

// Actions

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

class StartLoadingAction {
  StartLoadingAction();
}

class LoginSuccessAction {
  final LoginResponse user;

  LoginSuccessAction(this.user);
}

class LoginFailedAction {
  LoginFailedAction();
}

class LogoutAction {
  LogoutAction();
}

class GetGreetingRequestAction {
  GetGreetingRequestAction();
}

// Thunks

ThunkAction sendQuestionAction(String message, LoginResponse user) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(SendQuestionRequestAction(message));
      var settings = await getSettingsFromSharedPreferences();
      await sendQuestion(message, settings.voice, settings.generateAnswer, store.state.user).then(
          (msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
        if (msgRes.additionalResponse != '') {
          Future.delayed(const Duration(seconds: 3), () {
            store.dispatch(AddMessageAction(
                Message(message: msgRes.additionalResponse, sender: 'VA')));
          });
        }
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже',
                sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}

ThunkAction sendWrongAnswerAction(
    List<Message> messages, String msg, String userId) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(SendQuestionRequestAction(msg));
      await sendWrongAnswer(messages, userId).then((response) {
        store.dispatch(SendQuestionCompletedAction(response));
        getAudioAnswer(response.audioAnswer);
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже',
                sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}

ThunkAction loginUserAction(String userName, String password, context) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(StartLoadingAction());
      await login(userName, password).then((value) {
        store.dispatch(LoginSuccessAction(value));
        saveAuthData(userName, password);
        if (ModalRoute.of(context).settings.name != '/') {
          Keys.navKey.currentState.popUntil((route) => route.isFirst);
        }
      }, onError: (error) {
        store.dispatch(LoginFailedAction());
      });
    });
  };
}


ThunkAction getGreetingAction() {
  return (Store store) async {
    await Future(() async {
      store.dispatch(GetGreetingRequestAction());
      var settings = await getSettingsFromSharedPreferences();
      await getGreeting(settings.voice).then((msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже',
                sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}

ThunkAction getUserGreetingAction(LoginResponse user) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(GetGreetingRequestAction());
      var settings = await getSettingsFromSharedPreferences();
      await getUserGreeting(settings.voice, user).then((msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже',
                sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}

ThunkAction getAuthGreetingAction(LoginResponse user) {
  return (Store store) async {
    await Future(() async {
      store.dispatch(GetGreetingRequestAction());
      var settings = await getSettingsFromSharedPreferences();
      await getUserAuthGreeting(settings.voice, user).then((msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже',
                sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}

ThunkAction getLogoutGoodbyeAction() {
  return (Store store) async {
    await Future(() async {
      store.dispatch(GetGreetingRequestAction());
      var settings = await getSettingsFromSharedPreferences();
      await getUserLogoutGoodbye(settings.voice).then((msgRes) {
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(SendQuestionCompletedAction(msgRes));
          getAudioAnswer(msgRes.audioAnswer);
        });
      }, onError: (error) {
        store.dispatch(SendQuestionCompletedAction(MessageResponse(
            message: Message(
                message: 'Что-то пошло не так 😁. Попробуйте позже',
                sender: 'VA'),
            optionalQuestions: [])));
      });
    });
  };
}