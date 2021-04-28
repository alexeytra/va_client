import 'package:flutter/foundation.dart';
import 'package:va_client/models/message_model.dart';

class AppState {
  final List<Message> messages;
  List<String> optionalQuestions;
  bool listening = false;
  bool visibilityFloatingAction = true;
  bool visibilityInput = false;
  bool typing = false;
  bool areOptionalQuestions = false;

  AppState({this.messages,
    this.optionalQuestions,
    this.listening,
    this.visibilityFloatingAction,
    this.visibilityInput,
    this.typing,
    this.areOptionalQuestions});

  AppState.initialState()
      :
        messages = List.unmodifiable(<Message>[
          Message(
              sender: 'VA',
              message:
              "Привет! Я - Виртуальный ассистент, Ваш верный помощник. "
                  "Чем могу помочь?")
        ]),
        optionalQuestions = List.unmodifiable(<String>[]);
}
