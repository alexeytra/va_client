import 'package:redux/redux.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';

AppState appStateReducer(AppState state, dynamic action) {
  // if (action is AddMessageAction) {
  //   return AppState(
  //       messages: []
  //         ..addAll(state.messages)
  //         ..add(action.addedMessage));
  // }

  switch (action) {
    case AddMessageAction:
      return AppState(
          messages: []
            ..addAll(state.messages)
            ..add(action.addedMessage),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ProcessTypingAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: action.processTyping,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeAreOptionsQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: state.visibilityInput,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: action.changeAreOptionsQuestions);

    case ChangeVisibilityInputAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: state.visibilityInput,
          visibilityInput: action.changeVisibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeVisibilityFloatingAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: action.changeVisibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeListeningAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: action.changeListening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case RemoveLastMessageAction:
      return AppState(
          messages: []
            ..addAll(state.messages)
            ..removeLast(),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ClearOptionalQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: [],
          listening: state.listening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case AddOptionalQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: []..addAll(action.areOptionalQuestions),
          listening: state.listening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeAreOptionalQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloatingAction: state.visibilityFloatingAction,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: action.changeAreOptionalQuestions);

    default:
      return state;
  }
}
