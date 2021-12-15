import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import 'types.dart';

class CsafeShortCommand {
  CsafeCommandIdentifier command;

  // int get byteLength => command.type == CsafeCommandType.short ? 1 : ;

  CsafeShortCommand.fromByte(int byte)
      : command = CsafeCommandIdentifier(byte & 0xFF) {
    if (command.type == CsafeCommandType.long) {
      throw FormatException(
          "Long Command byte cannot be used to initialize a short command");
    }
  }
}

class CsafeLongCommand extends CsafeDataStructure {
  CsafeLongCommand(
      CsafeCommandIdentifier identifier, int byteLength, Uint8List data)
      : super(identifier, byteLength, data);
}

/// A CSAFE identifier byte representing a particular command
///
/// This class provides a `type` getter for detecting if this represents a long or short command
class CsafeCommandIdentifier extends Equatable {
  final int identifier;
  int get byteLength => 1;

  CsafeCommandType get type =>
      (identifier >= 0x80) ? CsafeCommandType.short : CsafeCommandType.long;

  CsafeCommandIdentifier(this.identifier);

  @override
  List<Object> get props => [identifier];
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
}

/// Represents a CSAFE status byte
class CsafeStatus extends Equatable {
  // The frame count is toggled by every frame received by the Server that is OK
  final int frameCount;
  final CsafePreviousFrameState prevState;
  final CsafeServerState serverState;

  /// Returns the length of this structure when written out to bytes
  int get byteLength => 1;

  /// Reads in and parses CSAFE data from bytes
  CsafeStatus.fromByte(int byte)
      : frameCount = (byte & 0x80) >> 7,
        prevState =
            CsafePreviousFrameStateExtension.fromInt((byte & 0x30) >> 4),
        serverState = CsafeServerStateExtension.fromInt(byte & 0x0F);

  /// Convert this status into a byte for transmission
  int toByte() {
    int byte = 0;
    byte |= frameCount;
    //shift over one because theres a reserved space, two for the prevState
    byte = byte << 3;
    byte |= prevState.value;
    byte = byte << 4;
    byte |= serverState.value;
    return byte;
  }

  @override
  List<Object> get props => [frameCount, prevState, serverState];
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
    dataCopy.insert(0, dataCopy.length);
    dataCopy.insert(0, identifier.identifier);
    return Uint8List.fromList(dataCopy);
  }

  @override
  List<Object> get props => [identifier, byteCount, data];
}
