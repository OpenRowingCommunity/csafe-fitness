import 'dart:typed_data';

import 'package:csafe_fitness/src/types/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for DateTime extension', () {
    Uint8List today = Uint8List.fromList([121, 12, 19]);

    test('test correct parsing', () {
      DateTime date = CsafeDateExtension.fromBytes(today);

      expect(date, DateTime(2021, 12, 19));
    });

    test('test correct dumping', () {
      DateTime date = DateTime(2021, 12, 19);

      expect(date.toBytes(), today);
    });
  });

  group('Tests for Duration extension', () {
    Uint8List now = Uint8List.fromList([4, 31, 5]);

    test('test correct parsing', () {
      Duration time = CsafeTimeExtension.fromBytes(now);

      expect(time, Duration(hours: 4, minutes: 31, seconds: 5));
    });

    test('test correct dumping', () {
      Duration time = Duration(hours: 4, minutes: 31, seconds: 5);

      expect(time.toBytes(), now);
    });
  });

  group('Tests for int extension', () {
    group('toBytes - ', () {
      test('can convert int to a uint8list', () {
        Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

        int integer = 3735928559;

        expect(integer.toBytes(), data);
      });

      test('can convert a smaller int to a uint8list without filling', () {
        Uint8List data = Uint8List.fromList([0xBE, 0xEF]);

        int integer = 48879;

        expect(integer.toBytes(), data);
      });

      test('can convert a smaller int to a uint8list with filling', () {
        Uint8List data = Uint8List.fromList([0x00, 0x00, 0xBE, 0xEF]);

        int integer = 48879;
        Uint8List parsedBytes = integer.toBytes(fillBytes: 4);
        expect(parsedBytes, data);
      });

      test(
          'can convert a smaller int to a little endian uint8list with filling',
          () {
        Uint8List data = Uint8List.fromList([0xEF, 0xBE, 0x00, 0x00]);

        int integer = 48879;
        Uint8List parsedBytes =
            integer.toBytes(fillBytes: 4, endian: Endian.little);
        expect(parsedBytes, data);
      });

      test('throws if too big of an integer is provided', () {
        expect(() => 257.toBytes(fillBytes: 1), throwsArgumentError);
        expect(() => 65537.toBytes(fillBytes: 2), throwsArgumentError);
        expect(() => 16777217.toBytes(fillBytes: 3), throwsArgumentError);
      });

      // test('can convert a negative int to a uint8list', () {
      //   Uint8List data = Uint8List.fromList([0xFF, 0xFF, 0xFF, 0xFF]);

      //   int integer = -1;

      //   expect(intToBytes(integer), data);
      // });

      // test('can convert a negative int to a uint8list with defined size', () {
      //   Uint8List data = Uint8List.fromList([0xFF]);

      //   int integer = -1;

      //   expect(intToBytes(integer, fillBytes: 1), data);
      // });
    });

    group('fromBytes - ', () {
      test('can combine large integer in big endian', () {
        Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

        expect(CsafeIntExtension.fromBytes(data), 3735928559);
      });

      test('can combine large integer in little endian', () {
        Uint8List data = Uint8List.fromList([0xEF, 0xBE, 0xAD, 0xDE]);

        expect(CsafeIntExtension.fromBytes(data, endian: Endian.little),
            3735928559);
      });

      test('correctly fails when combining too large of an integer', () {
        // Uint8List data = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

        // expect(CsafeIntExtension.fromBytes(data), throwsFormatException);
      });
    });
  });
}
