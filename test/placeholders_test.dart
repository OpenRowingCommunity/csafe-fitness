import 'dart:typed_data';

import 'package:csafe_fitness/src/types/enumtypes.dart';
import 'package:csafe_fitness/src/types/placeholders.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for CsafePlaceholder', () {
    Uint8List dead = Uint8List.fromList([0xDE, 0xAD]);
    Uint8List beef = Uint8List.fromList([0xBE, 0xEF]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

    test('test accepts', () {
      CsafePlaceholder bytesPlaceholder = CsafePlaceholder(2);

      expect(bytesPlaceholder.accepts(dead), true);

      bytesPlaceholder.bytes = dead;

      expect(bytesPlaceholder.bytes, dead);
    });
  });

  group('Tests for CsafeIntegerWithUnitsPlaceholder', () {
    Uint8List dead = Uint8List.fromList([0xDE, 0xAD, 0x24]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF, 0x24]);
    test('test correct parsing fromBytes', () {
      CsafeIntegerWithUnitsPlaceholder intUnits =
          CsafeIntegerWithUnitsPlaceholder.fromBytes(dead);

      expect(intUnits.integer, 57005);
      expect(intUnits.unit, CsafeUnits.meter);
    });

    test('test isFilled getter', () {
      CsafeIntegerWithUnitsPlaceholder intUnits =
          CsafeIntegerWithUnitsPlaceholder(2, UnitType.distance);

      expect(intUnits.isFilled, false);

      intUnits.integer = 5;
      intUnits.unit = CsafeUnits.meter;
      expect(intUnits.isFilled, true);
    });

    test('test symmetric parsing short', () {
      CsafeIntegerWithUnitsPlaceholder intUnits =
          CsafeIntegerWithUnitsPlaceholder.fromBytes(dead);

      expect(intUnits.toBytes(), dead);
    });

    test('test symmetric parsing long', () {
      CsafeIntegerWithUnitsPlaceholder intUnits =
          CsafeIntegerWithUnitsPlaceholder.fromBytes(deadbeef);

      expect(intUnits.toBytes(), deadbeef);
    });
  });

  group('Tests for CsafeTimePlaceholder', () {
    Uint8List timetest = Uint8List.fromList([5, 43, 2]);
    Duration d = Duration(hours: 5, minutes: 43, seconds: 2);

    test('test correct parsing fromBytes', () {
      CsafeTimePlaceholder time = CsafeTimePlaceholder.fromBytes(timetest);

      expect(time.time, d);
    });

    test('test isFilled getter', () {
      CsafeTimePlaceholder time = CsafeTimePlaceholder();

      expect(time.isFilled, false);
      time.time = d;
      expect(time.isFilled, true);
    });

    test('test symmetric parsing', () {
      CsafeTimePlaceholder time = CsafeTimePlaceholder.fromBytes(timetest);

      expect(time.toBytes(), timetest);
    });
  });

  group('Tests for CsafeDatePlaceholder', () {
    Uint8List timetest = Uint8List.fromList([5, 43, 2]);
    Duration d = Duration(hours: 5, minutes: 43, seconds: 2);

    test('test correct parsing fromBytes', () {
      CsafeTimePlaceholder time = CsafeTimePlaceholder.fromBytes(timetest);

      expect(time.time, d);
    });

    test('test isFilled getter', () {
      CsafeTimePlaceholder time = CsafeTimePlaceholder();

      expect(time.isFilled, false);
      time.time = d;
      expect(time.isFilled, true);
    });

    test('test symmetric parsing', () {
      CsafeTimePlaceholder time = CsafeTimePlaceholder.fromBytes(timetest);

      expect(time.toBytes(), timetest);
    });
  });
}
