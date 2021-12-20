import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import 'enumtypes.dart';
import 'datatypes.dart';

abstract class CsafeCommandFactory {
  int identifier;

  CsafeCommandFactory(this.identifier);
}

class CsafeLongCommandFactory extends CsafeCommandFactory {
  CsafeIntegerPlaceholderWithUnits placeholderValue;

  CsafeLongCommandFactory(int identifier, this.placeholderValue)
      : super(identifier);

  CsafeCommand buildFromValue(CsafeIntegerWithUnits value) {
    if (value.canFill(placeholderValue)) {
      return CsafeCommand.long(identifier, value.byteLength, value.toBytes());
    } else {
      throw FormatException(
          "Provided value does not satisfy placeholder requirements");
    }
  }
}

class CsafeShortCommandFactory extends CsafeCommandFactory {
  CsafeShortCommandFactory(int identifier) : super(identifier);

  CsafeCommand build() => CsafeCommand.short(identifier);
}

class CsafeCommand {
  CsafeCommandIdentifier command;
  CsafeDataStructure? data;

  CsafeCommandType get type => command.type;

  CsafeCommand(int commandId)
      : command = CsafeCommandIdentifier(commandId & 0xFF);

  CsafeCommand.short(int commandId)
      : command = CsafeCommandIdentifier(commandId & 0xFF) {
    if (command.type == CsafeCommandType.long) {
      throw FormatException(
          "Long Command byte cannot be used to initialize a short command");
    }
  }

  CsafeCommand.long(int commandId, int byteCount, Uint8List data)
      : command = CsafeCommandIdentifier(commandId & 0xFF) {
    if (command.type == CsafeCommandType.short) {
      throw FormatException(
          "Short Command byte cannot be used to initialize a long command");
    }

    this.data = CsafeDataStructure(command, byteCount, data);
  }

  Uint8List toBytes() {
    if (command.type == CsafeCommandType.short) {
      return Uint8List.fromList([command.toByte()]);
    } else if (data != null) {
      return data!.toBytes();
    } else {
      throw FormatException("The data field for a long command cannot be null");
    }
  }
}

class CsafeCommandResponse {
  CsafeStatus status;
  List<CsafeDataStructure> data = [];

  int get byteLength =>
      status.byteLength + data.map((e) => e.byteLength).reduce((a, b) => a + b);

  CsafeCommandResponse.fromBytes(Uint8List bytes)
      : status = CsafeStatus.fromByte(bytes.elementAt(0)) {
    // these are all the bytes that werent already used
    Uint8List remainingBytes = bytes.sublist(1);

    while (remainingBytes.isNotEmpty) {
      CsafeDataStructure thisData =
          CsafeDataStructure.fromBytes(remainingBytes);
      data.add(thisData);

      remainingBytes = remainingBytes.sublist(thisData.byteLength);
    }
  }

  Uint8List toBytes() {
    List<Uint8List> bytesList = [];
    bytesList.add(Uint8List.fromList([status.toByte()]));

    for (var item in data) {
      bytesList.add(item.toBytes());
    }

    return bytesList.reduce((a, b) => Uint8List.fromList(a + b));
  }

  bool matches(List<CsafeCommand> commands) {
    if (data.length != commands.length) return false;

    for (var i = 0; i < commands.length; i++) {
      if (data.elementAt(i).identifier != commands.elementAt(i).command) {
        return false;
      }
    }
    return true;
  }
}

/// Represents a structure containing an identifier (command), and some data with a known length.
///
/// This is used as both the long command format and also as a piece of the response structure.
class CsafeDataStructure extends Equatable {
  final CsafeCommandIdentifier identifier;
  final int byteCount;
  final Uint8List data;

  /// calculates the length if this were written out to bytes
  ///
  /// the +1 is to account for the 1 byte taken up by the byteCount
  int get byteLength => data.length + identifier.byteLength + 1;

  CsafeDataStructure(this.identifier, this.byteCount, this.data);

  /// Reads in and parses CSAFE data from bytes
  CsafeDataStructure.fromBytes(Uint8List bytes)
      : identifier = CsafeCommandIdentifier(bytes.first),
        byteCount = bytes.elementAt(1),
        data = bytes.sublist(2, bytes.elementAt(1) + 2);

  /// Writes the data out to bytes
  Uint8List toBytes() {
    List<int> dataCopy = data.toList();
    if (dataCopy.length > byteCount) {
      dataCopy = dataCopy.sublist(0, byteCount + 1);
    }
    dataCopy.insert(0, dataCopy.length);
    dataCopy.insert(0, identifier.identifier);
    return Uint8List.fromList(dataCopy);
  }

  @override
  List<Object> get props => [identifier, byteCount, data];
}
