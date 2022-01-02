import 'dart:typed_data';

import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';
import 'package:csafe_fitness/src/types/extensions.dart';
import 'package:csafe_fitness/src/validators.dart';
import 'package:test/test.dart';

void main() {
  Uint8List csafeDataBytes = Uint8List.fromList([0xAB, 0x02, 0x0, 0xF2]);

  Uint8List csafeLongDataBytes =
      Uint8List.fromList([0xAB, 0x02, 0x0, 0xF2, 0xF3, 0xF4]);
  group('Tests for validateLength', () {
    test('test validates correct value', () {
      Validator v = validateLength(4);

      expect(v(csafeDataBytes.asCsafe(), shouldThrow: false), true);
    });

    test('test doesnt validate long data', () {
      Validator v = validateLength(4);
      expect(() => v(csafeLongDataBytes.asCsafe(), shouldThrow: true),
          throwsArgumentError);
    });
  });
}
