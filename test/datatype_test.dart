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

  group('Tests for CsafeInteger', () {
    Uint8List dead = Uint8List.fromList([0xAD, 0xDE]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]);
    test('test correct parsing fromBytes', () {
      CsafeInteger intUnits = CsafeInteger.fromBytes(dead);

      expect(intUnits.value, 57005);
    });

    test('test symmetric parsing short', () {
      CsafeInteger intUnits = CsafeInteger.fromBytes(dead);

      expect(intUnits.toBytes(), dead);
    });

    test('test symmetric parsing long', () {
      CsafeInteger intUnits = CsafeInteger.fromBytes(deadbeef);

      expect(intUnits.toBytes(), deadbeef);
    });
  });

  group('Tests for CsafeIntegerWithUnits', () {
    Uint8List dead = Uint8List.fromList([0xAD, 0xDE, 0x24]);
    Uint8List deadbeef = Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF, 0x24]);
    test('test correct parsing fromBytes', () {
      CsafeIntegerWithUnits intUnits = CsafeIntegerWithUnits.fromBytes(dead);

      expect(intUnits.value, 57005);
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

    test('test meters constructor generates the right bytes', () {
      expect(CsafeIntegerWithUnits.meters(2000).toBytes(),
          Uint8List.fromList([0xD0, 0x07, 0x24]));
    });

    test('test kilometers constructor generates the right bytes', () {
      expect(CsafeIntegerWithUnits.kilometers(2).toBytes(),
          Uint8List.fromList([0x02, 0x00, 0x21]));
    });

    test('test watts constructor generates the right bytes', () {
      expect(CsafeIntegerWithUnits.watts(300).toBytes(),
          Uint8List.fromList([0x2C, 0x01, 0x58]));
    });
  });
}
