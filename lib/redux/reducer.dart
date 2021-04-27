import 'package:va_client/models/message_model.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';

AppState addMessage(AppState state, dynamic action) {
  if (action is AddMessageAction) {
    return AppState(
        messages: []
          ..addAll(state.messages)
          ..add(action.addedMessage));
  }

  return state;
}
