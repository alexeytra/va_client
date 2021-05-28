import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class APIManager {
  static final api = 'http://192.168.0.102:5000';

  static Future<dynamic> sendQuestionApi(Map param) async {
    return post(param, '/va/api/v1/question/text');
  }

  static Future<dynamic> sendWrongAnswerApi(Map param) async {
    return post(param, '/va/api/v1/answer/wrong');
  }

  static Future<dynamic> sendUserReview(Map param) async {
    return post(param, '/va/api/v1/review');
  }

  static Future<dynamic> loginApi(Map param) async {
    return auth(param);
  }

  static Future<dynamic> getGreeting(Map param) async {
    return post(param, '/va/api/v1/greeting');
  }

  static Future<dynamic> getUserGreeting(Map param) async {
    return post(param, '/va/api/v1/user/greeting');
  }

  static Future<dynamic> getUserAuthGreeting(Map param) async {
    return post(param, '/va/api/v1/user/login');
  }

  static Future<dynamic> getUserLogoutGoodbye(Map param) async {
    return post(param, '/va/api/v1/user/logout');
  }

  static Future<dynamic> getUserInfo(Map param) async {
    return get(param, 'https://esstu.ru/mlk/api/v1/student/getInfo');
  }

  static dynamic post(Map param, String endpoint) async {
    var responseJson;
    try {
      final response = await http.post(
          (endpoint.contains('https') || endpoint.contains('http'))
              ? endpoint
              : api + endpoint,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(param));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('Error ' + e.toString());
    }
    return responseJson;
  }

  static dynamic get(Map param, String endpoint) async {
    var responseJson;
    try {
      final response = await http.get(
          (endpoint.contains('https') || endpoint.contains('http'))
              ? endpoint
              : api + endpoint,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + param['accessToken'],
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('Error ' + e.toString());
    }
    return responseJson;
  }

  static dynamic auth(Map param) async {
    var responseJson;
    var queryParameters = <String, String>{
      'client_id': 'personal_office_mobile',
      'client_secret': DotEnv().env['SECRET_KEY'].toString(),
      'response_type': 'token',
      'grant_type': 'password',
      'scope': 'trust',
      'username': param['userName'],
      'password': param['password'],
    };

    var uri = Uri.https('esstu.ru', '/auth/oauth/token', queryParameters);
    try {
      var response = await http.post(uri, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('Error ' + e.toString());
    }
    return responseJson;
  }

  static dynamic _response(http.Response response) {
    var responseJson;
    if (response.body != '') {
      responseJson = json.decode(response.body.toString());
    } else {
      responseJson = '';
    }
    switch (response.statusCode) {
      case 200:
        return {'status': response.statusCode, 'response': responseJson};
      case 400:
        return {'status': response.statusCode, 'response': responseJson};
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        return {'status': response.statusCode};
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
