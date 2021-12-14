import 'dart:typed_data';

import 'types.dart';

class CsafeCommand {}

/// A CSAFE identifier byte representing a particular command
///
/// This class provides a `type` getter for detecting if this represents a long or short command
class CsafeCommandIdentifier {
  int identifier;

  CsafeCommandType get type =>
      (identifier >= 0x80) ? CsafeCommandType.short : CsafeCommandType.long;

  CsafeCommandIdentifier(this.identifier);
}


class CsafeCommandResponse {}

/// Represents a CSAFE status byte
class CsafeStatus {
  // The frame count is toggled by every frame received by the Server that is OK
  int frameCount;
  CsafePreviousFrameState prevState;
  CsafeServerState serverState;

  /// Reads in and parses CSAFE data from bytes
  CsafeStatus.fromByte(int byte)
      : frameCount = (byte & 0x80) >> 7,
        prevState =
            CsafePreviousFrameStateExtension.fromInt((byte & 0x30) >> 4),
        serverState = CsafeServerStateExtension.fromInt(byte & 0x0F);

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
}

/// Represents a structure containing an identifier (command), and some data with a known length.
///
/// This is used as both the long command format and also as a piece of the response structure.
class CsafeDataStructure {
  CsafeCommandIdentifier identifier;
  int byteCount;
  Uint8List data;

  /// Reads in and parses CSAFE data from bytes
  CsafeDataStructure.fromBytes(Uint8List bytes)
      : identifier = CsafeCommandIdentifier(bytes.first),
        byteCount = bytes.elementAt(1),
        data = bytes.sublist(2, bytes.elementAt(1) + 2);

  Uint8List toBytes() {
    List<int> dataCopy = data.toList();
    dataCopy.insert(0, dataCopy.length);
    dataCopy.insert(0, identifier.identifier);
    return Uint8List.fromList(dataCopy);
  }
}
