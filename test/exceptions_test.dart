import 'package:mandrill/exceptions.dart';
import 'package:mandrill/messages.dart';
import 'package:test/test.dart';

void main() {
  group('MandrillException', () {
    test('.fromError() creates the right exception', () {
      ErrorResponse errorResponse;

      errorResponse = ErrorResponse()..name = 'Unknown_Template';
      expect(MandrillException.fromError(errorResponse),
          TypeMatcher<UnknownTemplateException>());

      errorResponse = ErrorResponse()..name = 'Invalid_CustomDNSPending';
      expect(MandrillException.fromError(errorResponse),
          TypeMatcher<InvalidCustomDnsPendingException>());
    });
  });
}
