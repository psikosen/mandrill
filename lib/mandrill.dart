import 'dart:async';

import 'package:conduit_codable/conduit_codable.dart';
import 'package:mandrill/client/client.dart';
import 'package:mandrill/messages.dart';

import 'src/utils.dart' as utils;

export 'package:mandrill/exceptions.dart';
export 'package:mandrill/messages.dart';

part 'src/resources/messages.dart';

/// The main class for mandrill.
///
/// You can use the helper function `createMandrill()` to get up and running.
class Mandrill {
  final MandrillClient client;

  final Messages messages;

  Mandrill(this.client) : messages = Messages(client);
}
