import 'dart:typed_data';

import 'package:csafe_fitness/src/types/enumtypes.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';
import 'package:csafe_fitness/src/types/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for CsafeCommandIdentifier', () {
    test('test detect short command', () {
      CsafeCommandIdentifier ids = CsafeCommandIdentifier(0xA1);

      expect(ids.type, CsafeCommandType.short);
    });

    test('test detect long command', () {
      CsafeCommandIdentifier idl = CsafeCommandIdentifier(0x6D);

      expect(idl.type, CsafeCommandType.long);
    });

    test('test bytelength', () {
      CsafeCommandIdentifier ids = CsafeCommandIdentifier(0xA1);
      expect(ids.byteLength, 1);
    });
  });

  group('Tests for CsafeStatus', () {
    test('test symmetric parse', () {
      int byte = 0xA1;
      CsafeStatus status = CsafeStatus.fromByte(byte);

      expect(status.toByte(), byte);
    });
  });

  group('Tests for CsafeBytesPlaceholder', () {
    Uint8List dead = Uint8List.fromList([0xDE, 0xAD]);
    Uint8List beef = Uint8List.fromList([0xBE, 0xEF]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);

    test('test setting bytes', () {
      CsafeBytesPlaceholder bytesPlaceholder = CsafeBytesPlaceholder(2);

      expect(bytesPlaceholder.bytes, null);

      bytesPlaceholder.bytes = dead;

      expect(bytesPlaceholder.bytes, dead);
    });

    test('test isFilled getter', () {
      CsafeBytesPlaceholder bytesPlaceholder = CsafeBytesPlaceholder(2);

      expect(bytesPlaceholder.isFilled, false);

      bytesPlaceholder.bytes = dead;

      expect(bytesPlaceholder.isFilled, true);
    });

    test('test setting too many bytes', () {
      CsafeBytesPlaceholder bytesPlaceholder = CsafeBytesPlaceholder(2);

      expect(bytesPlaceholder.bytes, null);

      bytesPlaceholder.bytes = deadbeef;

      expect(bytesPlaceholder.bytes, null);
    });

    test('test symmetric parsing short', () {
      CsafeBytesPlaceholder bytesPlaceholder = CsafeBytesPlaceholder(2);

      bytesPlaceholder.bytes = dead;

      expect(bytesPlaceholder.toBytes(), dead);
    });

    test('test symmetric parsing long', () {
      CsafeBytesPlaceholder bytesPlaceholder = CsafeBytesPlaceholder(4);

      bytesPlaceholder.bytes = deadbeef;

      expect(bytesPlaceholder.toBytes(), deadbeef);
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
          CsafeIntegerWithUnitsPlaceholder(2, CsafeUnits.meter);

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
