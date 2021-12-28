import 'dart:typed_data';

import 'package:csafe_fitness/src/types/datatypes.dart';
import 'package:csafe_fitness/src/types/enumtypes.dart';
import 'package:csafe_fitness/src/types/extensions.dart';
import 'package:csafe_fitness/src/types/placeholders.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for CsafePlaceholder', () {
    Uint8List dead = Uint8List.fromList([0xDE, 0xAD]);
    Uint8List beef = Uint8List.fromList([0xBE, 0xEF]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

    test('test accepts', () {
      CsafePlaceholder bytesPlaceholder = CsafePlaceholder(2);

      expect(bytesPlaceholder.accepts(dead.asCsafe()), true);
    });

    test('test rejects values that are too long', () {
      CsafePlaceholder bytesPlaceholder = CsafePlaceholder(2);

      expect(bytesPlaceholder.accepts(deadbeef.asCsafe()), false);
    });
  });

  group('Tests for CsafeIntegerWithUnitsPlaceholder', () {
    Uint8List dead = Uint8List.fromList([0xDE, 0xAD, 0x24]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF, 0x24]);

    CsafeIntegerWithUnitsPlaceholder distanceUnits =
        CsafeIntegerWithUnitsPlaceholder(3, UnitType.distance);
    test('test accepts correct values', () {
      CsafeIntegerWithUnits value = CsafeIntegerWithUnits.fromBytes(dead);

      expect(distanceUnits.accepts(value), true);
    });

    test('test rejects large values', () {
      CsafeIntegerWithUnits bigvalue =
          CsafeIntegerWithUnits.fromBytes(deadbeef);

      expect(distanceUnits.accepts(bigvalue), false);
    });

    test('test rejects values with nonmatching type', () {
      CsafeIntegerWithUnits value =
          CsafeIntegerWithUnits(50, CsafeUnits.amperes);

      expect(distanceUnits.accepts(value), false);
    });
  });

  group('Tests for CsafeTimePlaceholder', () {
    Uint8List timetest = Uint8List.fromList([5, 43, 2]);
    Duration d = Duration(hours: 5, minutes: 43, seconds: 2);

    CsafeTimePlaceholder timePlaceholder = CsafeTimePlaceholder();

    test('test accepts value', () {
      expect(timePlaceholder.accepts(d.asCsafe()), true);
    });
  });

  group('Tests for CsafeDatePlaceholder', () {
    Uint8List dateTest = Uint8List.fromList([2021, 5, 23]);
    DateTime dt = DateTime(2021, 05, 23);
    CsafeDatePlaceholder datePlaceholder = CsafeDatePlaceholder();
    test('test accepts value', () {
      expect(datePlaceholder.accepts(dt.asCsafe()), true);
    });
  });
}
