import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat/constants/api_path.dart';
import 'package:chat/constants/app_constants.dart';
import 'package:chat/models/data_model.dart';
import 'package:http/http.dart' as http;

class Services {
  Services._();

  /// rest apis header with token
  static Map<String, String> get _restApiHeaders => <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: kFirebaseServerKey,
      };

  static final _client = http.Client();

  ///
  static Uri _uri(String authority, String unencodedPath,
          [Map<String, String>? queryParameters]) =>
      Uri.http(authority, unencodedPath, queryParameters);

  //
  static Future<Data> sendFCMMessage(Map<String, dynamic> body) async {
    Uri url = _uri(Urls.baseUrl, Urls.sendFCMMessage);
    try {
      http.Response response = await _client.post(url,
          body: jsonEncode(body), headers: _restApiHeaders);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return Data.fromResponse(response);
      }
      return Data.fromResponse(response);
    } catch (exception) {
      return Data.fromException(exception);
    }
  }
}
