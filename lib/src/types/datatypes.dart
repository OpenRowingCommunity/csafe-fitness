import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:equatable/equatable.dart';

import 'enumtypes.dart';

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

///Represents a 3-byte "Integer plus Unit specifier" type
///
///Usually this is just a two-byte number, but theres at least one instance of a 4 byte integer (exluding the unit) in the spec
class CsafeIntegerWithUnits extends Equatable {
  final int integer;
  final int intByteSize;
  final CsafeUnits unit;

  CsafeIntegerWithUnits(this.integer, this.intByteSize, this.unit);

  CsafeIntegerWithUnits.fromBytes(Uint8List bytes)
      : integer = combineToInt(bytes.sublist(0, bytes.length - 1)),
        intByteSize = bytes.length - 1,
        unit = CsafeUnitsExtension.fromInt(bytes.last);

  Uint8List toBytes() {
    List<int> bytes = [];
    bytes.insert(0, integer & 0xFF);
    bytes.insert(0, (integer & 0xFF00) >> 8);
    if (intByteSize == 4) {
      bytes.insert(0, (integer & 0xFF0000) >> 16);
      bytes.insert(0, (integer & 0xFF000000) >> 24);
    }

    bytes.add(unit.value);
    return Uint8List.fromList(bytes);
  }

  // define some shortcut constructors for creating instances from the most common units.
  CsafeIntegerWithUnits.meters(this.integer)
      : unit = CsafeUnits.meter,
        intByteSize = 2;

  @override
  List<Object?> get props => [integer, unit];
}
