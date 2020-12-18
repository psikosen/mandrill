import 'dart:async';

import 'package:mandrill/client/client.dart';
import 'package:mandrill/exceptions.dart';
import 'package:mandrill/messages.dart';
import 'package:test/test.dart';

import 'test_data.dart' as test_data;

class TestMandrillClient extends MandrillClient {
  TestMandrillClient(String apiKey) : super(apiKey);

  @override
  Future request(Uri uri, Map<String, String> headers, String body) async {
    expect(uri.path, endsWith('/foo/bar.json'));
    expect(headers, options.headers);
    expect(body, '{"test":"value","key":"test-api-key"}');
    return {'_id': 'test-id'};
  }
}

void main() {
  group('Client', () {
    final apiKey = 'test-api-key';
    MandrillClient mandrillClient;

    setUp(() {
      mandrillClient = TestMandrillClient(apiKey);
    });

    group('defaultResponseParser()', () {
      test('properly handles Maps', () {
        final response = defaultResponseParser(SentMessage(), {'_id': 'my-id'});
        expect(response.id, 'my-id');
      });
      test('properly handles Lists', () {
        final response = defaultResponseParser(SentMessagesResponse(), [
          {'_id': 'my-id'},
          {'_id': 'my-id2'}
        ]);
        expect(response.sentMessages, hasLength(2));
        expect(response.sentMessages.first.id, 'my-id');
        expect(response.sentMessages.last.id, 'my-id2');
      });
      test('throws if the response cannot be parsed.', () {
        expect(() => defaultResponseParser(SentMessage(), 'Invalid'),
            throwsA(TypeMatcher<InvalidResponseException>()));

        expect(() => defaultResponseParser(SentMessage(), {}),
            throwsA(TypeMatcher<InvalidResponseException>()),
            reason: 'Should throw because the Map is not <String, dynamic>');
      });
    });

    group('.formatDate()', () {
      test('handles DateTime properly', () {
        final date = DateTime.utc(2000, 1, 2, 3, 4, 5);
        expect(MandrillClient.formatDate(date), '2000-01-02 03:04:05');
      });
      test('handles null properly', () {
        expect(MandrillClient.formatDate(null), null);
      });
    });
    group('handleResponse()', () {
      test('returns the JSON decoded body on success', () {
        var response = mandrillClient.handleResponse(200, '{"foo": "bar"}');
        expect(response, {'foo': 'bar'});
        response = mandrillClient.handleResponse(200, '["foo", "bar"]');
        expect(response, ['foo', 'bar']);
      });
      test('parses the error message on error, and throws a correct exception',
          () {
        try {
          mandrillClient.handleResponse(501, test_data.errorResponse);
        } catch (e) {
          expect(e, TypeMatcher<UnknownSubaccountException>());
          expect((e as UnknownSubaccountException).message,
              'No subaccount exists with the id \'customer-123\'');
        }
      });
      test(
          'throws InvalidResponseException if the '
          'returned error was not parseable', () {
        try {
          mandrillClient.handleResponse(501, 'Invalid response');
        } catch (e) {
          expect(e, TypeMatcher<InvalidResponseException>());
          expect((e as InvalidResponseException).message, 'Invalid response');
        }
      });
    });
    group('call()', () {
      test('makes correct request and returns properly parsed message',
          () async {
        final response = await mandrillClient.call<SentMessage>(
            'foo/bar', {'test': 'value'}, SentMessage());

        expect(response, TypeMatcher<SentMessage>());
        expect(response.id, 'test-id');
      });
    });
  });
}
