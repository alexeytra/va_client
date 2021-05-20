import 'package:va_client/models/login_response.dart';
import 'package:va_client/models/message_model.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/utils/api_manager.dart';
import 'package:va_client/utils/functions.dart';

Future<MessageResponse> sendQuestion(
    String message, bool voice, bool generateAnswer, LoginResponse user) async {
  var question = message.split('\s+');
  var response = await APIManager.sendQuestionApi({
    'question': question.take(10).join(' '),
    'voice': voice,
    'generateAnswer': generateAnswer,
    'userId': user?.userId ?? '',
    'token': user?.accessToken ?? '',
    'userType': user?.userType ?? ''
  }).then((value) {
    return getMessageResponseObject(value['status'], value['response']);
  }, onError: (error) {
    return Future.error(error);
  });

  return response;
}

Future<MessageResponse> sendWrongAnswer(
    List<Message> messages, String userId) async {
  var response = await APIManager.sendWrongAnswerApi(
      {'messages': messages, 'userId': userId}).then((value) {
    return getMessageResponseObject(value['status'], value['response']);
  }, onError: (e) {
    return Future.error(e);
  });

  return response;
}

Future<LoginResponse> login(String userName, String password) async {
  var response =
      await APIManager.auth({'userName': userName, 'password': password}).then(
          (value) {
    if (value['status'] != 400) {
      return getLoginResponseObject(value['status'], value['response']);
    } else {
      return Future.error(Error);
    }
  }, onError: (e) {
    return Future.error(e);
  });
  return response;
}

Future<MessageResponse> getGreeting(bool voice) async {
  var response = await APIManager.getGreeting({'voice': voice}).then((value) {
    if (value['status'] != 400) {
      return getMessageResponseObject(value['status'], value['response']);
    } else {
      return Future.error(Error);
    }
  }, onError: (e) {
    return Future.error(e);
  });
  return response;
}

Future<MessageResponse> getUserGreeting(bool voice, LoginResponse user) async {
  var response = await APIManager.getUserGreeting({
    'voice': voice,
    'userType': user.userType,
    'accessToken': user.accessToken
  }).then((value) {
    if (value['status'] != 400) {
      return getMessageResponseObject(value['status'], value['response']);
    } else {
      return Future.error(Error);
    }
  }, onError: (e) {
    return Future.error(e);
  });
  return response;
}

Future<MessageResponse> getUserAuthGreeting(bool voice, LoginResponse user) async {
  var response = await APIManager.getUserAuthGreeting({
    'voice': voice,
    'userType': user.userType,
    'accessToken': user.accessToken
  }).then((value) {
    if (value['status'] != 400) {
      return getMessageResponseObject(value['status'], value['response']);
    } else {
      return Future.error(Error);
    }
  }, onError: (e) {
    return Future.error(e);
  });
  return response;
}

Future<MessageResponse> getUserLogoutGoodbye(bool voice) async {
  var response = await APIManager.getUserLogoutGoodbye({
    'voice': voice,
  }).then((value) {
    if (value['status'] != 400) {
      return getMessageResponseObject(value['status'], value['response']);
    } else {
      return Future.error(Error);
    }
  }, onError: (e) {
    return Future.error(e);
  });
  return response;
}
