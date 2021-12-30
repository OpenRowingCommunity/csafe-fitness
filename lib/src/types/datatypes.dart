import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:csafe_fitness/src/interfaces.dart';
import 'package:equatable/equatable.dart';

import 'enumtypes.dart';

/// This is effectively an extension of Uint8List to implement the ByteSerializable interface
class CsafeBytes implements ByteSerializable {
  Uint8List _bytes;

  CsafeBytes(this._bytes);

  @override
  int get byteLength => _bytes.length;

  @override
  Uint8List toBytes() => _bytes;
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

/// A CSAFE identifier byte representing a particular command
///
/// This class provides a `type` getter for detecting if this represents a long or short command
class CsafeCommandIdentifier extends Equatable {
  final int identifier;
  int get byteLength => 1;

  CsafeCommandType get type =>
      (identifier >= 0x80) ? CsafeCommandType.short : CsafeCommandType.long;

  CsafeCommandIdentifier(this.identifier);

  int toByte() {
    return identifier;
  }

  @override
  List<Object> get props => [identifier];
}

/// Represents an integer from the CSAFE spec
class CsafeInteger extends Equatable implements ByteSerializable {
  int value;
  final int _byteLength;

  @override
  int get byteLength => _byteLength;

  CsafeInteger(this.value, this._byteLength);

  CsafeInteger.fromBytes(Uint8List bytes)
      : value = combineToInt(bytes.sublist(0, bytes.length),
            endian: Endian.little),
        _byteLength = bytes.length;

  @override
  Uint8List toBytes() {
    //3.2.1 General conventions: All integers are sent low byte first and are considered unsigned integers unless otherwise specified.
    return intToBytes(value, fillBytes: _byteLength, endian: Endian.little);
  }

  @override
  List<Object?> get props => [value, _byteLength];
}

/// Represents a "Integer plus Unit specifier" type from the CSAFE spec
///
/// This builds on top of [CsafeInteger] and adds a unit to it
class CsafeIntegerWithUnits extends CsafeInteger {
  CsafeUnits unit;

  @override
  int get byteLength => _byteLength + 1;

  CsafeIntegerWithUnits(value, this.unit, {int byteLength = 3})
      : super(value, byteLength - 1);

  CsafeIntegerWithUnits.meters(value, {int byteLength = 3})
      : unit = CsafeUnits.meter,
        super(value, byteLength - 1);
  CsafeIntegerWithUnits.kilometers(value, {int byteLength = 3})
      : unit = CsafeUnits.kilometer,
        super(value, byteLength - 1);

  CsafeIntegerWithUnits.fromBytes(Uint8List bytes)
      : unit = CsafeUnitsExtension.fromInt(bytes.last),
        super(
            combineToInt(bytes.sublist(0, bytes.length - 1),
                endian: Endian.little),
            bytes.length - 1);

  bool matchesType(UnitType type) => unit.unitType == type;

  @override
  Uint8List toBytes() {
    return combineTwoLists(super.toBytes(), Uint8List.fromList([unit.value]));
  }

  @override
  List<Object?> get props => [value, unit, _byteLength];
}
