import 'dart:typed_data';

import 'package:csafe_fitness/src/types/enumtypes.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';
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

  group('Tests for CsafeIntegerWithUnits', () {
    Uint8List dead = Uint8List.fromList([0xDE, 0xAD, 0x24]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF, 0x24]);

    test('test correct parsing', () {
      CsafeIntegerWithUnits intUnits = CsafeIntegerWithUnits.fromBytes(dead);

      expect(intUnits.integer, 57005);
      expect(intUnits.unit, CsafeUnits.meter);
    });

    test('test symmetric parsing short', () {
      CsafeIntegerWithUnits intUnits = CsafeIntegerWithUnits.fromBytes(dead);

      expect(intUnits.toBytes(), dead);
    });

    test('test symmetric parsing long', () {
      CsafeIntegerWithUnits intUnits =
          CsafeIntegerWithUnits.fromBytes(deadbeef);

      expect(intUnits.toBytes(), deadbeef);
    });
  });

  group('Tests for DateTime extension', () {
    Uint8List today = Uint8List.fromList([121, 12, 19]);

    test('test correct parsing', () {
      DateTime date = CsafeDate.fromBytes(today);

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
      Duration time = CsafeTime.fromBytes(now);

      expect(time, Duration(hours: 4, minutes: 31, seconds: 5));
    });

    test('test correct dumping', () {
      Duration time = Duration(hours: 4, minutes: 31, seconds: 5);

      expect(time.toBytes(), now);
    });
  });
}
