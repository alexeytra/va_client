import 'CustomException.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class APIManager {
  final api = 'http://127.0.0.1:5000/va/api/v1/';

  Future<dynamic> sendQuestionApi(Map param) async {
    var responseJson;
    print('param' + param.toString());
    try {
      final response = await http.post(api + 'question/text',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(param));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  dynamic _response(http.Response response) {
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
            'Error occurred while Communication with Server with StatusCode: ${response
                .statusCode}');
    }
  }
}
