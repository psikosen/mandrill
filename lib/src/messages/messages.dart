part of '../../messages.dart';

class RecipientType {
  final String id;

  static const to = RecipientType._('to');
  static const cc = RecipientType._('cc');
  static const bcc = RecipientType._('bcc');

  static const values = [to, cc, bcc];

  const RecipientType._(this.id);

  static RecipientType fromString(String id) =>
      values.firstWhere((type) => type.id == id);
}

class Recipient extends Encoding {
  final String email;
  final String name;
  final RecipientType type;

  Recipient({
    @required this.email,
    this.name,
    this.type = RecipientType.to,
  });

  @override
  void encode(KeyedArchive object) {
    object
      ..encode('email', email)
      ..encode('name', name)
      ..encode('type', type.id);
  }
}

class RecipientMergeVars extends Encoding {
  final String email;
  final Map<String, dynamic> vars;

  RecipientMergeVars({@required this.email, @required this.vars});

  @override
  void encode(KeyedArchive object) {
    object..encode('rcpt', email)..encode('vars', utils.toVarList(vars));
  }
}

class RecipientMetadata extends Encoding {
  final String email;
  final Map<String, dynamic> values;

  RecipientMetadata({@required this.email, @required this.values});

  @override
  void encode(KeyedArchive object) {
    object..encode('rcpt', email)..encode('values', values);
  }
}

class File extends Encoding {
  final String type;
  final String name;

  /// Base64 encoded String
  final String content;

  File({@required this.type, @required this.name, @required this.content});

  @override
  void encode(KeyedArchive object) {
    object
      ..encode('type', type)
      ..encode('name', name)
      ..encode('content', content);
  }
}

class OutgoingMessage extends Encoding {
  /// This field is ignored if `.sendTemplate()` is used.
  final String html;
  final String text;
  final String subject;
  final String fromEmail;
  final String fromName;
  final List<Recipient> to;
  final Map<String, String> headers;
  final bool important;
  final bool trackOpens;
  final bool trackClicks;
  final bool autoText;
  final bool autoHtml;
  final bool inlineCss;
  final bool urlStripQs;
  final bool preserveRecipients;
  final bool viewContentLink;
  final String bccAddress;
  final String trackingDomain;
  final String signingDomain;
  final String returnPathDomain;
  final bool merge;
  final String mergeLanguage;
  final Map<String, dynamic> globalMergeVars;
  final List<RecipientMergeVars> mergeVars;
  final List<String> tags;
  final String subaccount;
  final List<String> googleAnalyticsDomains;
  final String googleAnalyticsCampaign;
  final Map<String, String> metadata;
  final List<RecipientMetadata> recipientMetadata;
  final List<File> attachments;
  final List<File> images;

  OutgoingMessage({
    this.html,
    this.text,
    this.subject,
    this.fromEmail,
    this.fromName,
    this.to,
    this.headers,
    this.important,
    this.trackOpens,
    this.trackClicks,
    this.autoText,
    this.autoHtml,
    this.inlineCss,
    this.urlStripQs,
    this.preserveRecipients,
    this.viewContentLink,
    this.bccAddress,
    this.trackingDomain,
    this.signingDomain,
    this.returnPathDomain,
    this.merge,
    this.mergeLanguage,
    this.globalMergeVars,
    this.mergeVars,
    this.tags,
    this.subaccount,
    this.googleAnalyticsDomains,
    this.googleAnalyticsCampaign,
    this.metadata,
    this.recipientMetadata,
    this.attachments,
    this.images,
  });

  @override
  void encode(KeyedArchive object) {
    object
      ..encode('html', html)
      ..encode('text', text)
      ..encode('subject', subject)
      ..encode('from_email', fromEmail)
      ..encode('from_name', fromName)
      ..encodeObjects('to', to)
      ..encode('headers', headers)
      ..encode('important', important)
      ..encode('track_opens', trackOpens)
      ..encode('track_clicks', trackClicks)
      ..encode('auto_text', autoText)
      ..encode('auto_html', autoHtml)
      ..encode('inline_css', inlineCss)
      ..encode('url_strip_qs', urlStripQs)
      ..encode('preserve_recipients', preserveRecipients)
      ..encode('view_content_link', viewContentLink)
      ..encode('bcc_address', bccAddress)
      ..encode('tracking_domain', trackingDomain)
      ..encode('signing_domain', signingDomain)
      ..encode('return_path_domain', returnPathDomain)
      ..encode('merge', merge)
      ..encode('merge_language', mergeLanguage)
      ..encode('global_merge_vars', utils.toVarList(globalMergeVars))
      ..encodeObjects('merge_vars', mergeVars)
      ..encode('tags', tags)
      ..encode('subaccount', subaccount)
      ..encode('google_analytics_domains', googleAnalyticsDomains)
      ..encode('google_analytics_campaign', googleAnalyticsCampaign)
      ..encode('metadata', metadata)
      ..encodeObjects('recipient_metadata', recipientMetadata)
      ..encodeObjects('attachments', attachments)
      ..encodeObjects('images', images);
  }
}

class SentMessageStatus {
  final String id;

  static const sent = SentMessageStatus._('sent');
  static const queued = SentMessageStatus._('queued');
  static const scheduled = SentMessageStatus._('scheduled');
  static const rejected = SentMessageStatus._('rejected');
  static const invalid = SentMessageStatus._('invalid');

  static const values = [sent, queued, scheduled, rejected, invalid];

  const SentMessageStatus._(this.id);

  static SentMessageStatus fromString(String id) =>
      id == null ? null : values.firstWhere((type) => type.id == id);
}

class SentMessageRejectReason {
  final String id;

  static const hardBounce = SentMessageRejectReason._('hard-bounce');
  static const softBounce = SentMessageRejectReason._('soft-bounce');
  static const spam = SentMessageRejectReason._('spam');
  static const unsub = SentMessageRejectReason._('unsub');
  static const custom = SentMessageRejectReason._('custom');
  static const invalidSender = SentMessageRejectReason._('invalid-sender');
  static const invalid = SentMessageRejectReason._('invalid');
  static const testModeLimit = SentMessageRejectReason._('test-mode-limit');
  static const unsigned = SentMessageRejectReason._('unsigned');
  static const rule = SentMessageRejectReason._('rule');

  static const values = [
    hardBounce,
    softBounce,
    spam,
    unsub,
    custom,
    invalidSender,
    invalid,
    testModeLimit,
    unsigned,
    rule,
  ];

  const SentMessageRejectReason._(this.id);

  static SentMessageRejectReason fromString(String id) =>
      id == null ? null : values.firstWhere((type) => type.id == id);
}

class SentMessagesResponse extends MandrillResponse {
  List<SentMessage> sentMessages;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    sentMessages = object.decodeObjects('list', () => SentMessage());
  }
}

class SentMessage extends MandrillResponse {
  String id;
  String email;
  SentMessageStatus status;
  SentMessageRejectReason rejectReason;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    id = object.decode('_id');
    email = object.decode('email');
    status = SentMessageStatus.fromString(object.decode('status') as String);
    rejectReason =
        SentMessageRejectReason.fromString(object.decode('reject_reason'));
  }
}
