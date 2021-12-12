import 'dart:typed_data';

import 'package:csafe_fitness/src/command.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for CsafeData', () {
    Uint8List csafeDataBytes = Uint8List.fromList([0x02, 0x0, 0xF2]);

    Uint8List csafeLongDataBytes =
        Uint8List.fromList([0x02, 0x0, 0xF2, 0xF3, 0xF4]);

    test('test parse data bytes', () {
      CsafeData data = CsafeData.fromBytes(csafeDataBytes);
      expect(data.byteCount, 2);
      expect(data.data, Uint8List.fromList([0x0, 0xF2]));
    });

    test('test parse extraneously long data bytes', () {
      CsafeData data = CsafeData.fromBytes(csafeLongDataBytes);
      expect(data.byteCount, 2);
      expect(data.data, Uint8List.fromList([0x0, 0xF2]));
    });

    test('test symmetric parsing', () {
      CsafeData data = CsafeData.fromBytes(csafeDataBytes);
      expect(data.toBytes(), csafeDataBytes);
    });
  });
}
