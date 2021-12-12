import 'dart:typed_data';

enum CsafeCommandType { short, long }

enum CsafePreviousFrameState { ok, reject, bad, notReady }

extension CsafePreviousFrameStateExtension on CsafePreviousFrameState {
  int get value => index;
  static CsafePreviousFrameState fromInt(int i) =>
      CsafePreviousFrameState.values[i];
}

enum CsafeServerState {
  error,
  ready,
  idle,
  haveID,
  inUse,
  paused,
  finished,
  manual,
  offline
}

extension CsafeServerStateExtension on CsafeServerState {
  int get value {
    switch (this) {
      case CsafeServerState.error:
      case CsafeServerState.ready:
      case CsafeServerState.idle:
      case CsafeServerState.haveID:
        return index;
      case CsafeServerState.inUse:
        return 5;
      case CsafeServerState.paused:
        return 6;
      case CsafeServerState.finished:
        return 7;
      case CsafeServerState.manual:
        return 8;
      case CsafeServerState.offline:
        return 9;
    }
  }

  static CsafeServerState fromInt(int i) {
    switch (i) {
      case 0:
        return CsafeServerState.error;
      case 1:
        return CsafeServerState.ready;
      case 2:
        return CsafeServerState.idle;
      case 3:
        return CsafeServerState.haveID;
      case 5:
        return CsafeServerState.inUse;
      case 6:
        return CsafeServerState.paused;
      case 7:
        return CsafeServerState.finished;
      case 8:
        return CsafeServerState.manual;
      case 9:
        return CsafeServerState.offline;
      default:
        throw FormatException("value $i has no matching CsafeServerState");
    }
  }
}

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
