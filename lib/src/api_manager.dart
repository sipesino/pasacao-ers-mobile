import 'package:pers/src/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

class APIManager extends Model {
  Future<dynamic> postAPICall(String url, Map body) async {
    print("Calling API: $url");
    print("Calling parameters: $body");

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: body, headers: {
        'Accept': '*/*',
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('error: $e');
    }
    return responseJson;
  }

  Future<dynamic> getAPICall(String url, Map<String, String> param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: param);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print('error: $e');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
