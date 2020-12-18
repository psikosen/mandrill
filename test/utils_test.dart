import 'package:mandrill/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('utils', () {
    group('toVarList()', () {
      test('properly encodes maps', () {
        final result = toVarList({'k1': 'v1', 'k2': 'v2'});
        expect(result, [
          {'name': 'k1', 'content': 'v1'},
          {'name': 'k2', 'content': 'v2'},
        ]);
      });
      test('returns null if null is provided', () {
        expect(toVarList(null), null);
      });
    });
  });
}
