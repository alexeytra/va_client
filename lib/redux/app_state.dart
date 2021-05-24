import 'package:flutter/foundation.dart';
import 'package:va_client/models/user/login_response.dart';
import 'package:va_client/models/message/message_model.dart';

@immutable
class AppState {
  final List<Message> messages;
  final List<String> optionalQuestions;
  final bool listening;
  final bool visibilityFloating;
  final bool visibilityInput;
  final bool typing;
  final bool areOptionalQuestions;
  final String audioAnswer;
  final bool isLoading;
  final bool loginError;
  final isLogin;
  final LoginResponse user;

  AppState({
    @required this.messages,
    @required this.optionalQuestions,
    @required this.listening,
    @required this.visibilityFloating,
    @required this.visibilityInput,
    @required this.typing,
    @required this.areOptionalQuestions,
    @required this.isLoading,
    @required this.loginError,
    @required this.user,
    this.audioAnswer,
    @required this.isLogin,
  });

  AppState.initialState()
      : messages = List.unmodifiable(<Message>[]),
        optionalQuestions = List.unmodifiable(<String>[]),
        listening = false,
        visibilityFloating = true,
        visibilityInput = false,
        typing = false,
        areOptionalQuestions = true,
        audioAnswer = null,
        isLoading = false,
        loginError = false,
        isLogin = false,
        user = null;

  @override
  String toString() {
    return 'AppState{messages: $messages, optionalQuestions: $optionalQuestions, listening: $listening, visibilityFloating: $visibilityFloating, visibilityInput: $visibilityInput, typing: $typing, areOptionalQuestions: $areOptionalQuestions, audioAnswer: $audioAnswer, isLoading: $isLoading, loginError: $loginError, isLogin: $isLogin, user: $user}';
  }
}
