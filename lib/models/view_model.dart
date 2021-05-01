import 'package:redux/redux.dart';
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

  final Function(bool) changeListening;
  final Function(Message) addMessage;
  final Function(bool) changeTyping;
  final Function() removeLastMessage;
  final Function() clearOptionalQuestions;
  final Function(List<String>) addOptionalQuestions;
  final Function(bool) changeAreOptionalQuestions;
  final Function(bool) changeVisibilityFloating;
  final Function(bool) changeVisibilityInput;
  final Function(String) sendMessage;

  ViewModel({
    this.clearOptionalQuestions, this.addOptionalQuestions, this.changeAreOptionalQuestions,
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
    this.changeVisibilityInput,
    this.changeVisibilityFloating,
    this.optionalQuestions,
    this.sendMessage
  });

  factory ViewModel.create(Store<AppState> store) {
    _onChangeListening(bool listening) {
      store.dispatch(ChangeListeningAction(listening));
    }

    _onAddMessage(Message message) {
      store.dispatch(AddMessageAction(message));
    }

    _onChangeTyping(bool typing) {
      store.dispatch(ProcessTypingAction(typing));
    }

    _onRemoveLastMessage() {
      store.dispatch(RemoveLastMessageAction());
    }

    _onClearOptionalQuestions() {
      store.dispatch(ClearOptionalQuestionsAction());
    }

    _onAddOptionalQuestions(List<String> optQuestions) {
      store.dispatch(AddOptionalQuestionsAction(optQuestions));
    }

    _onChangeAreOptionalQuestions(bool areOptQuestions) {
      store.dispatch(ChangeAreOptionalQuestionsAction(areOptQuestions));
    }
    
    _onChangeVisibilityFloating(bool visibilityFloating) {
      store.dispatch(ChangeVisibilityFloatingAction(visibilityFloating));
    }

    _onChangeVisibilityInput(bool visibilityInput) {
      store.dispatch(ChangeVisibilityInputAction(visibilityInput));
    }
    
    return ViewModel(
        listening: store.state.listening,
        messages: store.state.messages,
        visibilityFloating: store.state.visibilityFloatingAction,
        typing: store.state.typing,
        areOptionalQuestions: store.state.areOptionalQuestions,
        visibilityInput: store.state.visibilityInput,
        optionalQuestions: store.state.optionalQuestions,
        sendMessage: (String message) {
          store.dispatch(sendMessage(message));
        },

        changeVisibilityFloating: _onChangeVisibilityFloating,
        changeListening: _onChangeListening,
        addMessage: _onAddMessage,
        changeTyping: _onChangeTyping,
        removeLastMessage: _onRemoveLastMessage,
        clearOptionalQuestions: _onClearOptionalQuestions,
        addOptionalQuestions: _onAddOptionalQuestions,
        changeAreOptionalQuestions: _onChangeAreOptionalQuestions,
        changeVisibilityInput: _onChangeVisibilityInput,
    );
  }
}