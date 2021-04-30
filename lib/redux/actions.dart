import 'package:va_client/models/message_model.dart';
// add
class AddMessageAction {
  final Message addedMessage;

  AddMessageAction(this.addedMessage);
}

// add
class ProcessTypingAction {
  final bool processTyping;

  ProcessTypingAction(this.processTyping);
}

//add
class ChangeAreOptionsQuestionsAction {
  final bool changeAreOptionsQuestions;

  ChangeAreOptionsQuestionsAction(this.changeAreOptionsQuestions);
}

class ChangeVisibilityInputAction {
  final bool changeVisibilityInput;

  ChangeVisibilityInputAction(this.changeVisibilityInput);
}

class ChangeVisibilityFloatingAction {
  final bool changeVisibilityFloating;

  ChangeVisibilityFloatingAction(this.changeVisibilityFloating);
}

class ChangeListeningAction {
  final bool changeListening;

  ChangeListeningAction(this.changeListening);
}

class RemoveLastMessageAction {
  RemoveLastMessageAction();
}

class ClearOptionalQuestionsAction {
  ClearOptionalQuestionsAction();
}

class AddOptionalQuestionsAction {
  final List<String> areOptionalQuestions;

  AddOptionalQuestionsAction(this.areOptionalQuestions);
}

class ChangeAreOptionalQuestionsAction {
  final bool changeAreOptionalQuestions;

  ChangeAreOptionalQuestionsAction(this.changeAreOptionalQuestions);
}

