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
  });
}
