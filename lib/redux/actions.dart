import 'package:va_client/models/message_model.dart';

class AddMessageAction {
  final Message addedMessage;

  AddMessageAction(this.addedMessage);
}

class ProcessTypingAction {
  final bool processTyping;

  ProcessTypingAction(this.processTyping);
}

class ChangeAreOptionsQuestionsAction {
  final bool changeAreOptionsQuestions;

  ChangeAreOptionsQuestionsAction(this.changeAreOptionsQuestions);
}

class ChangeVisibilityInputAction {
  final bool changeVisibilityInput;

  ChangeVisibilityInputAction(this.changeVisibilityInput);
}

class ChangeVisibilityFloatingActionAction {
  final bool changeVisibilityFloatingAction;

  ChangeVisibilityFloatingActionAction(this.changeVisibilityFloatingAction);
}

class ChangeListeningAction {
  final bool changeListening;

  ChangeListeningAction(this.changeListening);
}