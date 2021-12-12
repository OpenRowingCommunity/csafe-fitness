import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:csafe_fitness/src/frame.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Uint8List emptyFrameBytes = Uint8List.fromList([0xF1, 0x0, 0xF2]);

    Uint8List someFrameInvalidChecksum =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x0, 0xF2]);
    Uint8List someFrameValidChecksum =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x22, 0xF2]);

    setUp(() {
      // Additional setup goes here.
    });

    test('test parse empty frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(emptyFrameBytes);
      expect(frame.checksum, 0);
      expect(frame.frameContents, Uint8List.fromList([]));
    });

    test('test parse nonempty frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(someFrameInvalidChecksum);
      expect(frame.checksum, 0);
      expect(frame.frameContents, Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]));
    });

    test('test synnetric parsing', () {
      CsafeFrame frame = CsafeFrame.fromBytes(someFrameInvalidChecksum);

      expect(frame.toBytes(), someFrameInvalidChecksum);
    });

    test('test checksum validation for an empty frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(emptyFrameBytes);

      expect(frame.validate(), true);
    });

    test('test checksum validation for an empty frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(emptyFrameBytes);

      expect(frame.validate(), true);
    });

    test('test checksum validation for an invalid frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(someFrameInvalidChecksum);

      expect(frame.validate(), false);
    });

    test('test checksum validation for an valid frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(someFrameValidChecksum);

      expect(frame.validate(), true);
    });
  });
}
