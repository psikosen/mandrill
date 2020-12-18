import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:codable/codable.dart';
import 'package:logging/logging.dart';
import 'package:mandrill/exceptions.dart';
import 'package:mandrill/messages.dart';

class MandrillOptions {
  final String scheme;
  final String host;
  final int port;
  final String pathPrefix;
  final Map<String, String> headers;

  const MandrillOptions({
    this.scheme = 'https',
    this.host = 'mandrillapp.com',
    this.port = 443,
    this.pathPrefix = '/api/1.0/',
    this.headers = const {
      'Content-Type': 'application/json',
      'User-Agent': 'Mandrill-Dart/1.0.4'
    },
  });
}

typedef ResponseParser<T extends MandrillResponse> = T Function(
    T responseCoding, dynamic response);

/// The default [ResponseParser] simply takes the response Map, and invokes
/// `.decode(archive)` on the provided [Coding] object.
///
/// If the response is a [List], then it will be converted to a Map:
/// `{'list': response}`.
T defaultResponseParser<T extends MandrillResponse>(
    T responseCoding, dynamic response) {
  if (response is List) {
    response = <String, dynamic>{'list': response};
  } else if (response is! Map<String, dynamic>) {
    // If this exception is thrown here, it probably means that you need to
    // provide your own ResponseParser (or Mandrill is bugging out).
    throw InvalidResponseException('The returned response was not a Map.');
  }
  final archive = KeyedArchive.unarchive(response as Map<String, dynamic>);
  return responseCoding..decode(archive);
}

/// The base class for the Mandrill HTTP client.
/// There is a server and a browser implementation of this client.
abstract class MandrillClient {
  final _log = Logger('MandrillClient');

  final String apiKey;

  final MandrillOptions options;

  MandrillClient(this.apiKey, [MandrillOptions options])
      : options = options ?? const MandrillOptions();

  Future<T> call<T extends MandrillResponse>(
      String path, Map body, T responseCoding,
      {ResponseParser<T> responseParser}) async {
    final uri = Uri(
      scheme: options.scheme,
      host: options.host,
      port: options.port,
      path: '${options.pathPrefix}$path.json',
    );

    final bodyWithKey = Map.from(body)..['key'] = apiKey;

    _log.finer('Making Mandrill request to $uri');
    final responseMap =
        await request(uri, options.headers, jsonEncode(bodyWithKey));

    T response;
    if (responseParser == null) {
      response = defaultResponseParser<T>(responseCoding, responseMap);
    } else {
      response = responseParser(responseCoding, responseMap);
    }
    return response;
  }

  /// The function that does the actual HTTP request.
  Future<dynamic> request(Uri uri, Map<String, String> headers, String body);

  /// Parses the body and returns a [Map] of the decoded json.
  /// If the [statusCode] is not 200, then a [MandrillException] is thrown.
  dynamic handleResponse(int statusCode, String body) {
    if (statusCode != 200) {
      MandrillException error;
      try {
        final errorArchive =
            KeyedArchive.unarchive(jsonDecode(body) as Map<String, dynamic>);
        final errorResponse = ErrorResponse()..decode(errorArchive);

        error = MandrillException.fromError(errorResponse);
      } catch (e) {
        _log.warning(
            'The body returned by Mandrill could not be parsed properly: $e');
        error = InvalidResponseException(body);
      }
      throw error;
    }

    return jsonDecode(body);
  }

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Formats a [DateTime] the way the Mandrill API expects it.
  static String formatDate(DateTime date) =>
      date == null ? null : _dateFormat.format(date.toUtc());
}
