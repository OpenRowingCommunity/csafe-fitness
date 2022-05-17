import 'dart:typed_data';

import 'package:csafe_fitness/src/frame.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for Csafe', () {
    Uint8List emptyFrameBytes = Uint8List.fromList([0xF1, 0x0, 0xF2]);

    Uint8List someFrameInvalidChecksum =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x0, 0xF2]);
    Uint8List someFrameValidChecksum =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x22, 0xF2]);

    //set up streams
    setUp(() {
      // Additional setup goes here.
      //set up subscriptions probably
    });

    test('test sendCommand adds to pending list', () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(emptyFrameBytes);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([]));
    });

    test('test read function removes from queue', () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameInvalidChecksum);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]));
    });

    test('test handle invalid CRC', () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameInvalidChecksum);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]));
    });

    test('test handle unsolicited packet', () {
      // CsafeFrame frame = CsafeFrame.fromEncodedBytes(someFrameInvalidChecksum);
      // expect(frame.checksum, 0);
      // expect(frame.frameContents, Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]));
    });
  });
}
