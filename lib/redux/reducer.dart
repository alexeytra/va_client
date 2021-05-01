import 'package:va_client/models/message_model.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';

AppState appStateReducer(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case AddMessageAction:
      return AppState(
          messages: [...state.messages]..add(action.addedMessage),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ProcessTypingAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: action.processTyping,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeAreOptionsQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityInput,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: action.changeAreOptionsQuestions);

    case ChangeVisibilityInputAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityInput,
          visibilityInput: action.changeVisibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeVisibilityFloatingAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: action.changeVisibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeListeningAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: action.changeListening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case RemoveLastMessageAction:
      return AppState(
          messages: [...state.messages]..removeLast(),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ClearOptionalQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: [],
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case AddOptionalQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: [...action.areOptionalQuestions],
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions);

    case ChangeAreOptionalQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: action.changeAreOptionalQuestions);

    case SendQuestionRequestAction:
      return AppState(
          messages: [...state.messages]
            ..add(Message(iconTyping: 'assets/typing.gif', sender: 'VA')),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: true,
          areOptionalQuestions: state.areOptionalQuestions);

    case SendQuestionCompletedAction:
      return AppState(
          messages: ([...state.messages]..removeLast())
            ..add(action.msg),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: false,
          areOptionalQuestions: state.areOptionalQuestions);


    default:
      return state;
  }
}
