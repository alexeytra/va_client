import 'package:flutter/foundation.dart';
import 'package:va_client/models/login_response.dart';
import 'package:va_client/models/message_model.dart';

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
  final LoginResponse user;

  AppState(
      {@required this.messages,
      @required this.optionalQuestions,
      @required this.listening,
      @required this.visibilityFloating,
      @required this.visibilityInput,
      @required this.typing,
      @required this.areOptionalQuestions,
      this.isLoading,
      this.loginError,
      @required this.user,
      this.audioAnswer});

  AppState.initialState()
      : messages = List.unmodifiable(<Message>[
          Message(
              sender: 'VA',
              message:
                  'Добрый день! Я - Виртуальный ассистент. Чем могу помочь?')
        ]),
        optionalQuestions =
            List.unmodifiable(<String>['👍', '👎', 'Привет', 'Как дела']),
        listening = false,
        visibilityFloating = true,
        visibilityInput = false,
        typing = false,
        areOptionalQuestions = true,
        audioAnswer = null,
        isLoading = false,
        loginError = false,
        user = null;

  @override
  String toString() {
    return 'AppState{messages: $messages, optionalQuestions: $optionalQuestions, listening: $listening, visibilityFloating: $visibilityFloating, visibilityInput: $visibilityInput, typing: $typing, areOptionalQuestions: $areOptionalQuestions, audioAnswer: $audioAnswer, isLoading: $isLoading, loginError: $loginError, user: $user}';
  }
}
