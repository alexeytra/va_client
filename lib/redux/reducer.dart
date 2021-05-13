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
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user);

    case ProcessTypingAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: action.processTyping,
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user);

    case ChangeAreOptionsQuestionsAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityInput,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: action.changeAreOptionsQuestions,
          user: state.user);

    case ChangeVisibilityInputTypeAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: action.visibilityFloating,
          visibilityInput: action.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user);

    case ChangeListeningAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: action.changeListening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user);

    case RemoveLastMessageAction:
      return AppState(
          messages: [...state.messages]..removeLast(),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user);

    case SendQuestionRequestAction:
      return AppState(
          messages: [...state.messages]..add(
              Message(message: action.message, sender: 'USER'))..add(
              Message(iconTyping: 'assets/typing.gif', sender: 'VA')),
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: true,
          areOptionalQuestions: state.areOptionalQuestions && false,
          user: state.user);

    case SendQuestionCompletedAction:
      return AppState(
          messages: ([...state.messages]..removeLast())
            ..add(action.msgRes.message),
          optionalQuestions: []..addAll(['👍', '👎'])..addAll(
              action.msgRes.optionalQuestions),
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: false,
          audioAnswer: action.msgRes.audioAnswer,
          areOptionalQuestions: true,
          user: state.user);

    case StartLoadingAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user,
          isLoading: true);

    case LoginSuccessAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: action.user,
          isLogin: true);

    case LoginFailedAction:
      return AppState(
          messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: state.user,
          loginError: true);

    case LogoutAction:
      return AppState(messages: state.messages,
          optionalQuestions: state.optionalQuestions,
          listening: state.listening,
          visibilityFloating: state.visibilityFloating,
          visibilityInput: state.visibilityInput,
          typing: state.typing,
          areOptionalQuestions: state.areOptionalQuestions,
          user: null,
          isLogin: false
      );

    default:
      return state;
  }
}
