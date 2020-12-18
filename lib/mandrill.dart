import 'dart:async';

import 'package:codable/codable.dart';
import 'package:mandrill/client/client.dart';
import 'package:mandrill/messages.dart';

import 'src/utils.dart' as utils;

export 'package:mandrill/exceptions.dart';
export 'package:mandrill/messages.dart';

part 'src/resources/messages.dart';

class Mandrill {
  final MandrillClient client;

  final Messages messages;

  Mandrill(this.client) : messages = Messages(client);
}
