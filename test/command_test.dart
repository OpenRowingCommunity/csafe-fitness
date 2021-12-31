import 'dart:typed_data';

import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';
import 'package:csafe_fitness/src/types/extensions.dart';
import 'package:csafe_fitness/src/types/placeholders.dart';
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

    test('test matching with one Command', () {
      CsafeCommandResponse resp =
          CsafeCommandResponse.fromBytes(csafeResponseDataBytes);
      CsafeCommand cmd = CsafeCommand.short(0xAB);
      expect(resp.matches([cmd]), true);
    });

    test('test matching with multiple Commands', () {
      Uint8List csafeMultiResponseDataBytes =
          Uint8List.fromList([0x93, 0xAB, 0x02, 0x0, 0xF2, 0xAC, 0x01, 0xEF]);
      CsafeCommandResponse resp =
          CsafeCommandResponse.fromBytes(csafeMultiResponseDataBytes);
      CsafeCommand cmd = CsafeCommand.short(0xAB);
      CsafeCommand cmd2 = CsafeCommand.short(0xAC);
      expect(resp.matches([cmd, cmd2]), true);
    });
  });

  group('Tests for CsafeLongCommandFactory', () {
    test("init", () {
      CsafeLongCommandFactory factory =
          CsafeLongCommandFactory(0x23, CsafePlaceholder(2));

      expect(factory.identifier, 0x23);
      expect(factory.placeholderValue, CsafePlaceholder(2));
    });

    test("buildFromValue", () {
      CsafeLongCommandFactory factory =
          CsafeLongCommandFactory(0x23, CsafePlaceholder(2));

      CsafeCommand cmd =
          factory.buildFromValue(Uint8List.fromList([1, 2]).asCsafe());

      expect(cmd.command, CsafeCommandIdentifier(factory.identifier));
      expect(
          cmd.data,
          CsafeDataStructure(
              CsafeCommandIdentifier(0x23), 2, Uint8List.fromList([1, 2])));
    });

    // raises if placeholder requirements not satisfied
    test("validate", () {
      CsafeLongCommandFactory factory =
          CsafeLongCommandFactory(0x23, CsafePlaceholder(2));

      CsafeCommand cmd =
          factory.buildFromValue(Uint8List.fromList([1, 2]).asCsafe());

      expect(cmd.command, CsafeCommandIdentifier(factory.identifier));
      expect(
          cmd.data,
          CsafeDataStructure(
              CsafeCommandIdentifier(0x23), 2, Uint8List.fromList([1, 2])));
    });
  });

  group('Tests for CsafeCommand', () {
    test('test fails if given long command id in short command', () {
      expect(() => CsafeCommand.short(0x12), throwsFormatException);
    });

    test('test constructor', () {
      int byte = 0x85;

      CsafeCommand cmd = CsafeCommand(byte);
      expect(cmd.command, CsafeCommandIdentifier(byte));
      expect(CsafeCommand.short(byte).toBytes(), Uint8List.fromList([byte]));
    });

    test('test generates short binary properly', () {
      int byte = 0x85;
      expect(CsafeCommand.short(byte).toBytes(), Uint8List.fromList([byte]));
    });

    test('test fails if given short command id in long command', () {
      expect(() => CsafeCommand.long(0x85, 0, Uint8List.fromList([]).asCsafe()),
          throwsFormatException);
    });

    test('test generates long binary properly', () {
      int byte = 0x12;
      var data = Uint8List.fromList([1, 2]);
      var result = [0x12, 2, 1, 2];
      expect(CsafeCommand.long(byte, 2, data.asCsafe()).toBytes(),
          Uint8List.fromList(result));
    });

    test('test long command throws when serialized with no parameter', () {
      //   int byte = 0x12;
      //   var data = Uint8List.fromList([1, 2]);
      //   var result = [0x12, 2, 1, 2];
      //   expect(CsafeCommand.long(byte, 2, data).toBytes(),
      //       Uint8List.fromList(result));
      // });
    });

    test('test getting the byte length for a short command', () {
      int byte = 0x85;
      expect(CsafeCommand.short(byte).byteLength, 1);
    });

    test('test getting the byte length for a long command', () {
      CsafeCommand cmd =
          CsafeCommand.long(0x23, 2, Uint8List.fromList([1, 2]).asCsafe());

      expect(cmd.byteLength, 4);
    });
  });
}
