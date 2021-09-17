import 'package:mandrill/client/client.dart';
import 'package:mandrill/client/client_server.dart';

import 'package:mandrill/mandrill.dart';

export 'package:mandrill/mandrill.dart';
export 'package:mandrill/messages.dart';
export 'package:mandrill/exceptions.dart';

/// A helper function to easily create a configured [Mandrill] object with a
/// functioning HTTP client.
Mandrill createMandrill(String apiKey, [MandrillOptions? options]) =>
    Mandrill(ServerClient(apiKey, options));
