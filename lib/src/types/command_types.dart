import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import 'enumtypes.dart';
import 'datatypes.dart';

abstract class CsafeCommandFactory {
  int identifier;

  CsafeCommandFactory(this.identifier);
}

/// Acts as a generator for Csafe Long commands with certain values pre-filled
///
/// This allows libraries such as this one to provide a set of command objects that the suer can use to generate commmands without needing to interact with raw byte/hexadecimal values. Because long commands include additional data/parameters, the user needs to provide a value to [buildFromValue] in order for the generated commands to be sendable
class CsafeLongCommandFactory extends CsafeCommandFactory {
  CsafeBytesPlaceholder placeholderValue;

  CsafeLongCommandFactory(int identifier, this.placeholderValue)
      : super(identifier);

  CsafeCommand buildFromValue(CsafeBytesPlaceholder value) {
    if (value.validate()) {
      return CsafeCommand.long(identifier, value.byteLength, value.toBytes());
    } else {
      throw FormatException(
          "Provided value does not satisfy placeholder requirements");
    }
  }
}

/// Acts as a generator for Csafe Short commands with the identifier pre-filled
///
/// This allows libraries such as this one to provide a set of command objects that the suer can use to generate commmands without needing to interact with raw byte/hexadecimal values. Because short commands have no additional parameters, no additional input is needed to generate valid commands
class CsafeShortCommandFactory extends CsafeCommandFactory {
  CsafeShortCommandFactory(int identifier) : super(identifier);

  CsafeCommand build() => CsafeCommand.short(identifier);
}

/// Represents a CSAFE command with all the parameters needed to send to a device
class CsafeCommand {
  CsafeCommandIdentifier command;
  CsafeDataStructure? data;

  CsafeCommandType get type => command.type;

  int get byteLength {
    if (command.type == CsafeCommandType.short) {
      return 1;
    } else {
      // long command
      return data!.byteLength;
    }
  }

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

/// Represents the response to one or many CSAFE commands
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

  /// Determines if this is a response to the given list of commands.
  ///
  /// this is used for matching the commands to their responses when processing the data.
  /// TODO: Currently this will not work with Csafe frames that do not respond to every command or send unsolicited commands.
  ///
  bool matches(List<CsafeCommand> commands) {
    if (data.length != commands.length) return false;

    for (var i = 0; i < commands.length; i++) {
      if (data.elementAt(i).identifier != commands.elementAt(i).command) {
        return false;
      }
    }
    return true;
  }

  //TODO: maybe a mthod to match commands to their responses so each command can be turned into a commandWithValue or something similar?
}

/// Represents a structure containing an identifier (command), and a single data element with a known length.
///
/// This is used as both the long command format and also as a piece of the response structure.
class CsafeDataStructure extends Equatable {
  final CsafeCommandIdentifier identifier;

  /// The size of [data] in bytes
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
