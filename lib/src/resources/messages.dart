part of '../../mandrill.dart';

class Messages {
  final MandrillClient client;

  Messages(this.client);

  /// - `sendAsync`: enable a background sending mode that is optimized for bulk
  ///   sending. In async mode, messages/send will immediately return a status
  ///   of "queued" for every recipient. To handle rejections when sending in
  ///   async mode, set up a webhook for the 'reject' event. Defaults to false
  ///   for messages with no more than 10 recipients; messages with more than 10
  ///   recipients are always sent asynchronously, regardless of the value of
  ///   async.
  ///
  /// - `ipPool`: the name of the dedicated ip pool that should be used to send
  ///   the message. If you do not have any dedicated IPs, this parameter has no
  ///   effect. If you specify a pool that does not exist, your default pool
  ///   will be used instead.
  ///
  /// - `sendAt`: when this message should be sent. If you specify a time in the
  ///   past, the message will be sent immediately. An additional fee applies
  ///   for scheduled email, and this feature is only available to accounts with
  ///   a positive balance.
  Future<SentMessagesResponse> send(
    OutgoingMessage message, {
    bool sendAsync = false,
    String? ipPool,
    DateTime? sendAt,
  }) async {
    final body = {
      'message': KeyedArchive.archive(message),
      'async': sendAsync,
      'ip_pool': ipPool,
      'send_at': MandrillClient.formatDate(sendAt),
    };

    return await client.call('messages/send', body, SentMessagesResponse());
  }

  /// - `templateName`: the immutable name or slug of a template that exists in
  ///   the user's account. For backwards-compatibility, the template name may
  ///   also be used but the immutable slug is preferred.
  ///
  /// - `templateContent`: a Map where the key is the content block to set the
  ///   content for, and the value is the actual content to put into the block.
  ///
  /// For `sendAsync`, `ipPool` and `sendAt` please look at the [send]
  /// documentation.
  Future<SentMessagesResponse> sendTemplate(
    String templateName,
    OutgoingMessage message, {
    Map<String, String>? templateContent,
    bool sendAsync = false,
    String? ipPool,
    DateTime? sendAt,
  }) async {
    final body = {
      'template_name': templateName,
      'template_content': utils.toVarList(templateContent),
      'message': KeyedArchive.archive(message),
      'async': sendAsync,
      'ip_pool': ipPool,
      'send_at': MandrillClient.formatDate(sendAt),
    };

    return await client.call(
        'messages/send-template', body, SentMessagesResponse());
  }
}
