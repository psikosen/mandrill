import 'dart:convert';

import 'package:codable/codable.dart';
import 'package:mandrill/messages.dart';
import 'package:test/test.dart';

import '../test_data.dart' as test_data;

void main() {
  group('Messages', () {
    group('RecipientType', () {
      test('.fromString() works with all types', () {
        expect(RecipientType.fromString('to'), RecipientType.to);
        expect(RecipientType.fromString('cc'), RecipientType.cc);
        expect(RecipientType.fromString('bcc'), RecipientType.bcc);
        expect(() => RecipientType.fromString('foo'),
            throwsA(TypeMatcher<StateError>()));
      });
    });
    group('Recipient', () {
      test('properly encodes object', () {
        final recipient =
            Recipient(email: 'dr.fr@nkenstein.com', name: 'Mr. F');
        final archive = KeyedArchive.archive(recipient);

        expect(archive['email'], recipient.email);
        expect(archive['name'], recipient.name);
        expect(archive['type'], RecipientType.to.id);
      });
      test('properly encodes different types', () {
        final recipient = Recipient(
            email: 'dr.fr@nkenstein.com',
            name: 'Mr. F',
            type: RecipientType.bcc);
        final archive = KeyedArchive.archive(recipient);
        expect(archive['type'], RecipientType.bcc.id);
      });
    });
    group('RecipientMergeVars', () {
      test('properly encodes object', () {
        final recipient = RecipientMergeVars(
            email: 'recip@ient.com', vars: {'foo': 'bar', 'foo2': 'bar2'});
        final archive = KeyedArchive.archive(recipient);

        expect(archive['rcpt'], recipient.email);
        expect(archive['vars'], TypeMatcher<List>());
        expect(archive['vars'].length, 2);
        expect(archive['vars'][0], {'name': 'foo', 'content': 'bar'});
        expect(archive['vars'][1], {'name': 'foo2', 'content': 'bar2'});
      });
    });
    group('RecipientMetadata', () {
      test('properly encodes object', () {
        final recipient = RecipientMetadata(
            email: 'recip@ient.com', values: {'foo': 'bar', 'foo2': 'bar2'});
        final archive = KeyedArchive.archive(recipient);

        expect(archive['rcpt'], recipient.email);
        expect(archive['values'], TypeMatcher<Map>());
        expect(archive['values'].length, 2);
        expect(archive['values']['foo'], 'bar');
        expect(archive['values']['foo2'], 'bar2');
      });
    });
    group('File', () {
      test('properly encodes object', () {
        final recipient = File(
            type: 'text/plain',
            name: 'myfile.txt',
            content: 'ZXhhbXBsZSBmaWxl');
        final archive = KeyedArchive.archive(recipient);

        expect(archive['type'], recipient.type);
        expect(archive['name'], recipient.name);
        expect(archive['content'], recipient.content);
      });
    });
    group('OutgoingMessage', () {
      test('properly encodes object', () {
        final recipient = OutgoingMessage(
          html: '<p>Example HTML content</p>',
          text: 'Example text content',
          subject: 'example subject',
          fromEmail: 'message.from_email@example.com',
          fromName: 'Example Name',
          to: [
            Recipient(
                email: 'recipient.email@example.com', name: 'Recipient Name'),
            Recipient(
                email: 'recipient2.email@example.com',
                name: 'Recipient Name 2',
                type: RecipientType.bcc),
          ],
          headers: {'Reply-To': 'message.reply@example.com'},
          important: false,
          trackOpens: true,
          trackClicks: false,
          autoText: true,
          autoHtml: false,
          inlineCss: true,
          urlStripQs: false,
          preserveRecipients: true,
          viewContentLink: false,
          bccAddress: 'message.bcc_address@example.com',
          trackingDomain: 'tracking.domain',
          signingDomain: 'signing.domain',
          returnPathDomain: 'return.path.domain',
          merge: true,
          mergeLanguage: 'mailchimp',
          globalMergeVars: {'merge1': 'merge1 content'},
          mergeVars: [
            RecipientMergeVars(
                email: 'recipient.email@example.com',
                vars: {'merge2': 'merge2 content'})
          ],
          tags: ['password-resets'],
          subaccount: 'customer-123',
          googleAnalyticsDomains: ['example.com'],
          googleAnalyticsCampaign: 'message.from_email@example.com',
          metadata: {'website': 'www.example.com'},
          recipientMetadata: [
            RecipientMetadata(
                email: 'recipient.email@example.com',
                values: {'user_id': 123456})
          ],
          attachments: [
            File(
                type: 'text/plain',
                name: 'myfile.txt',
                content: 'ZXhhbXBsZSBmaWxl')
          ],
          images: [
            File(
                type: 'image/png',
                name: 'image.png',
                content: 'ZXhhbXBsZSBmaWxl')
          ],
        );
        final archive = KeyedArchive.archive(recipient);

        final archiveJson = jsonDecode(jsonEncode(archive));
        final testJson = jsonDecode(test_data.message);

        expect(archiveJson, testJson);
      });
      test('properly handles null values', () {
        final recipient = OutgoingMessage();
        final archive = KeyedArchive.archive(recipient);

        final archiveJson = jsonDecode(jsonEncode(archive));

        expect(archiveJson, {});
      });
    });
    group('SentMessageResponse', () {
      test('properly decodes object', () {
        final json = jsonDecode(test_data.sendMessageResponse);
        final archive = KeyedArchive.unarchive({'list': json});
        final sentMessageResponse = SentMessagesResponse()..decode(archive);

        expect(sentMessageResponse.sentMessages.length, 2);

        final sentMessage0 = sentMessageResponse.sentMessages.first;
        final sentMessage1 = sentMessageResponse.sentMessages.last;

        expect(sentMessage0.id, json[0]['_id']);
        expect(sentMessage0.email, json[0]['email']);
        expect(sentMessage0.status.id, json[0]['status']);
        expect(sentMessage0.rejectReason, isNull);

        expect(sentMessage1.id, json[1]['_id']);
        expect(sentMessage1.email, json[1]['email']);
        expect(sentMessage1.status.id, json[1]['status']);
        expect(sentMessage1.rejectReason.id, json[1]['reject_reason']);
      });
    });
  });
}
