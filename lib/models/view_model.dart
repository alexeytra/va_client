import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:va_client/models/login_response.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';

import 'message_model.dart';

class ViewModel {
  final bool listening;
  final bool areOptionalQuestions;
  final bool visibilityFloating;
  final List<Message> messages;
  final bool typing;
  final bool visibilityInput;
  final List<String> optionalQuestions;
  final String audioAnswer;
  final bool isLoading;
  final bool loginError;
  final bool isLogin;
  final LoginResponse loginResponse;

  final Function(bool) changeListening;
  final Function(Message) addMessage;
  final Function(bool) changeTyping;
  final Function() removeLastMessage;
  final Function(String, LoginResponse) sendMessage;
  final Function(bool, bool) changeInputType;
  final Function(List<Message>, String, String) sendWrongAnswer;
  final Function(String, String, BuildContext) login;
  final Function() logout;

  ViewModel(
      {this.isLoading,
      this.loginError,
      this.loginResponse,
      this.listening,
      this.visibilityFloating,
      this.areOptionalQuestions,
      this.messages,
      this.typing,
      this.changeListening,
      this.addMessage,
      this.changeTyping,
      this.removeLastMessage,
      this.visibilityInput,
      this.optionalQuestions,
      this.sendMessage,
      this.audioAnswer,
      this.sendWrongAnswer,
      this.changeInputType,
      this.isLogin,
      this.login, this.logout});

  factory ViewModel.create(Store<AppState> store) {
    void _onChangeListening(bool listening) {
      store.dispatch(ChangeListeningAction(listening));
    }

    void _onAddMessage(Message message) {
      store.dispatch(AddMessageAction(message));
    }

    void _onChangeTyping(bool typing) {
      store.dispatch(ProcessTypingAction(typing));
    }

    void _onRemoveLastMessage() {
      store.dispatch(RemoveLastMessageAction());
    }

    void _onChangeInputType(bool visibilityInput, bool visibilityFloating) {
      store.dispatch(
          ChangeVisibilityInputTypeAction(visibilityInput, visibilityFloating));
    }

    return ViewModel(
        listening: store.state.listening,
        messages: store.state.messages,
        visibilityFloating: store.state.visibilityFloating,
        typing: store.state.typing,
        areOptionalQuestions: store.state.areOptionalQuestions,
        visibilityInput: store.state.visibilityInput,
        optionalQuestions: store.state.optionalQuestions,
        audioAnswer: store.state.audioAnswer,
        isLogin: store.state.isLogin,
        loginResponse: store.state.user,
        isLoading: store.state.isLogin,
        loginError: store.state.loginError,
        sendMessage: (String message, LoginResponse user) {
          store.dispatch(sendQuestionAction(message, user));
        },
        logout: () => store.dispatch(LogoutAction()),
        changeListening: _onChangeListening,
        addMessage: _onAddMessage,
        changeTyping: _onChangeTyping,
        removeLastMessage: _onRemoveLastMessage,
        changeInputType: _onChangeInputType,
        sendWrongAnswer: (List<Message> messages, String msg, String userId) {
          store.dispatch(sendWrongAnswerAction(messages, msg, userId));
        },
        login: (String userName, String password, context) {
          store.dispatch(loginUser(userName, password, context));
        });
  }
}
