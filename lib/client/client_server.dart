import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:mandrill/client/client.dart';

class ServerClient extends MandrillClient {
  ServerClient(String apiKey, [MandrillOptions? options])
      : super(apiKey, options);

  @override
  Future<dynamic> request(
      Uri uri, Map<String, String> headers, String body) async {
    final response = await http.post(uri, headers: headers, body: body);
    return handleResponse(response.statusCode, response.body);
  }
}
