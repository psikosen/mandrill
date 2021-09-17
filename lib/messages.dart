import 'package:conduit_codable/conduit_codable.dart';

import 'src/utils.dart' as utils;

part 'src/messages/error.dart';
part 'src/messages/messages.dart';

/// Use this class if you do not intend on implementing [Coding.encode].
abstract class MandrillResponse extends Coding {
  /// Not implemented. Do not invoke!
  @override
  void encode(_) => throw UnimplementedError('This message cannot be encoded.');
}

/// Use this class if you do not intend on implementing [Coding.decode].
abstract class Encoding extends Coding {
  /// Not implemented. Do not invoke!
  @override
  // ignore: must_call_super
  void decode(_) => throw UnimplementedError('This message cannot be decoded.');
}
