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
}
