import 'dart:typed_data';

import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/bytetypes.dart';

import 'package:test/test.dart';

void main() {
  group('Tests for CsafeDataStructure', () {
    Uint8List csafeDataBytes = Uint8List.fromList([0xAB, 0x02, 0x0, 0xF2]);

    Uint8List csafeLongDataBytes =
        Uint8List.fromList([0xAB, 0x02, 0x0, 0xF2, 0xF3, 0xF4]);

    test('test parse data bytes', () {
      CsafeDataStructure data = CsafeDataStructure.fromBytes(csafeDataBytes);
      expect(data.byteCount, 2);
      expect(data.data, Uint8List.fromList([0x0, 0xF2]));
    });

    test('test parse extraneously long data bytes', () {
      CsafeDataStructure data =
          CsafeDataStructure.fromBytes(csafeLongDataBytes);
      expect(data.byteCount, 2);
      expect(data.data, Uint8List.fromList([0x0, 0xF2]));
    });

    test('test symmetric parsing', () {
      CsafeDataStructure data = CsafeDataStructure.fromBytes(csafeDataBytes);
      expect(data.toBytes(), csafeDataBytes);
    });

    test('test bytelength', () {
      CsafeDataStructure data = CsafeDataStructure.fromBytes(csafeDataBytes);
      expect(data.byteLength, 4);
    });
  });

  group('Tests for CsafeCommandResponse', () {
    Uint8List csafeResponseDataBytes =
        Uint8List.fromList([0x93, 0xAB, 0x02, 0x0, 0xF2]);

    test('test correct parsing', () {
      CsafeCommandResponse resp =
          CsafeCommandResponse.fromBytes(csafeResponseDataBytes);

      List<CsafeDataStructure> expected = [
        CsafeDataStructure.fromBytes(csafeResponseDataBytes.sublist(1))
      ];

      expect(resp.status, CsafeStatus.fromByte(0x93));
      expect(resp.data, expected);
    });

    test('test symmetric parse', () {
      CsafeCommandResponse resp =
          CsafeCommandResponse.fromBytes(csafeResponseDataBytes);

      expect(resp.toBytes(), csafeResponseDataBytes);
    });

    test('test bytelength', () {
      CsafeStatus status = CsafeStatus.fromByte(0xA1);
      expect(status.byteLength, 1);
    });
  });
}
