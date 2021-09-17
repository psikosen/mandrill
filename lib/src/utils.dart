/// Converts a Map to a Mandrill List:
///
///     {'AAA key': 'AAA value', 'BBB key': 'BBB value'}
///     // becomes
///     [
///       {'name': 'AAA key', 'content': 'AAA value'},
///       {'name': 'BBB key', 'content': 'BBB value'},
///     ]
/// If `null` is provided as [vars], then `null` is returned.
List<Map<String, dynamic>>? toVarList(Map<String, dynamic>? vars) => vars ==
        null
    ? null
    : vars.keys
        .map<Map<String, dynamic>>((key) => {'name': key, 'content': vars[key]})
        .toList(growable: false);
