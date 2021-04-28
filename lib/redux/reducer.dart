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

  switch(action){
    case AddMessageAction:
      return AppState(
          messages: []
            ..addAll(state.messages)
            ..add(action.addedMessage));

    case ProcessTypingAction:
      return AppState(typing: !state.typing);

    default:
      return state;
  }

  return state;
}
