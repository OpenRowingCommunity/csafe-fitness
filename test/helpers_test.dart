import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for Helper methods', () {
    test('can combine large integer', () {
      Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

      expect(combineToInt(data), 3735928559);
    });
  });
}
