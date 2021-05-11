import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class APIManager {
  static final api = 'http://127.0.0.1:5000/va/api/v1/';

  static Future<dynamic> sendQuestionApi(Map param) async {
    return post(param, 'question/text');
  }

  static Future<dynamic> sendWrongAnswerApi(Map param) async {
    return post(param, 'answer/wrong');
  }

  static Future<dynamic> loginApi(Map param) async {
    return auth(param);
  }

  static dynamic post(Map param, String endpoint) async {
    var responseJson;
    try {
      final response = await http.post(api + endpoint,
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
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return {'status': response.statusCode, 'response': responseJson};
      case 400:
        throw BadRequestException(response.body.toString());
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
