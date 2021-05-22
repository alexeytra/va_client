import 'package:va_client/models/login_response.dart';
import 'package:va_client/models/message_response.dart';
import 'package:va_client/utils/api_manager.dart';
import 'package:va_client/utils/functions.dart';

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

Future<String> getUserInfo(String accessToken) async {
  var response = await APIManager.getUserLogoutGoodbye({
    'accessToken': accessToken,
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