import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:csafe_fitness/src/frame.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Uint8List emptyFrameBytes = Uint8List.fromList([0xF1, 0x0, 0xF2]);

    Uint8List someFrame =
        Uint8List.fromList([0xF1, 0xDE, 0xAD, 0xBE, 0xEF, 0x0, 0xF2]);

    setUp(() {
      // Additional setup goes here.
    });

    test('test parse empty frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(emptyFrameBytes);
      expect(frame.checksum, 0);
      expect(frame.frameContents, Uint8List.fromList([]));
    });

    test('test parse nonempty frame', () {
      CsafeFrame frame = CsafeFrame.fromBytes(someFrame);
      expect(frame.checksum, 0);
      expect(frame.frameContents, Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]));
    });
  });
}
