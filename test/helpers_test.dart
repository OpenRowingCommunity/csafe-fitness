import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for Helper methods', () {
    test('can combine large integer', () {
      Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

      expect(combineToInt(data), 3735928559);
    });

    test('correctly fails when combining too large of an integer', () {
      // Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

      // expect(combineToInt(data), 3735928559);
    });

    test('can combine two uint8lists', () {
      Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

      Uint8List data2 = Uint8List.fromList([0xEF, 0xBE, 0xAD, 0xDE]);

      expect(combineTwoLists(data, data2),
          Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF, 0xEF, 0xBE, 0xAD, 0xDE]));
    });

    test('can convert int to a uint8list', () {
      Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

      int integer = 3735928559;

      expect(intToBytes(integer), data);
    });

    test('can convert a smaller int to a uint8list without filling', () {
      Uint8List data = Uint8List.fromList([0xBE, 0xEF]);

      int integer = 48879;

      expect(intToBytes(integer), data);
    });

    test('can convert a smaller int to a uint8list with filling', () {
      Uint8List data = Uint8List.fromList([0x00, 0x00, 0xBE, 0xEF]);

      int integer = 48879;
      Uint8List parsedBytes = intToBytes(integer, fillBytes: 4);
      expect(parsedBytes, data);
    });

    test('can convert a smaller int to a little endian uint8list with filling',
        () {
      Uint8List data = Uint8List.fromList([0xEF, 0xBE, 0x00, 0x00]);

      int integer = 48879;
      Uint8List parsedBytes =
          intToBytes(integer, fillBytes: 4, endian: Endian.little);
      expect(parsedBytes, data);
    });
  });
}
