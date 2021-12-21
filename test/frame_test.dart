import 'dart:typed_data';

import 'package:csafe_fitness/src/frame.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for the CsafeFrame', () {
    Uint8List emptyFrameBytes = Uint8List.fromList([0xF1, 0x0, 0xF2]);

    Uint8List someFrameInvalidChecksum =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x0, 0xF2]);
    Uint8List someFrameValidChecksum =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x22, 0xF2]);

    setUp(() {
      // Additional setup goes here.
    });

    test('test can autogenerate valid checksum', () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(emptyFrameBytes);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([]));
    });

    test('test empty frame shortcut', () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(emptyFrameBytes);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([]));
    });

    test('test parse empty frame', () {
      CsafeFrame frame = CsafeFrame.fromEncodedBytes(emptyFrameBytes);
      expect(frame.checksum, 0);
      expect(frame.frameContents, Uint8List.fromList([]));
    });

    test(
        'test proper escaping of contents containing the start and/or end bytes',
        () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(emptyFrameBytes);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([]));
    });

    test('test parse nonempty frame', () {
      CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameInvalidChecksum);
      expect(frame.checksum, 0);
      expect(frame.frameContents, Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]));
    });

    test('test synnetric parsing', () {
      CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameInvalidChecksum);

      expect(frame.toBytes(), someFrameInvalidChecksum);
    });

    test('test checksum validation for an empty frame', () {
      CsafeFrame frame = CsafeFrame.fromEncodedBytes(emptyFrameBytes);

      expect(frame.validate(), true);
    });

    test('test checksum validation for an invalid frame', () {
      CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameInvalidChecksum);

      expect(frame.validate(), false);
    });

    test('test checksum validation for a valid frame', () {
      CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameValidChecksum);

      expect(frame.validate(), true);
    });
  });
}
