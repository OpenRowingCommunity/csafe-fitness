import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:csafe_fitness/src/interfaces.dart';
import 'package:equatable/equatable.dart';

import 'enumtypes.dart';

/// An alias to describe functions that take in a [ByteSerializable] and perform some validation check on it
typedef Validator = bool Function(ByteSerializable, {bool shouldThrow});

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
/// TODO: maybe merge with IntegerWithUnits and have options to extend it/allow it to switch for the concept2 numbers if intuiive.
class _CsafeInteger extends Equatable implements ByteSerializable {
  final int value;
  final int _byteLength;
  final Endian endian = Endian.little;

  @override
  int get byteLength => _byteLength;

  _CsafeInteger(this.value, this._byteLength);

  /// Create a CsafeInteger from a set of bytes
  ///
  /// If the input bytes are not little endian, change the [inputEndian] parameter to account for this
  // _CsafeInteger.fromBytes(Uint8List bytes, {Endian inputEndian = Endian.little})
  //     : value =
  //           combineToInt(bytes.sublist(0, bytes.length), endian: inputEndian),
  //       _byteLength = bytes.length;

  @override
  Uint8List toBytes() {
    //3.2.1 General conventions: All integers are sent low byte first and are considered unsigned integers unless otherwise specified.
    return intToBytes(value, fillBytes: _byteLength, endian: endian);
  }

  @override
  List<Object?> get props => [value, _byteLength];
}

/// Represents a "Integer plus Unit specifier" type from the CSAFE spec
///
/// This builds on top of [CsafeInteger] and adds a unit to it
class CsafeIntegerWithUnits extends _CsafeInteger {
  final CsafeUnits unit;

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

  CsafeIntegerWithUnits.watts(value, {int byteLength = 3})
      : unit = CsafeUnits.watts,
        super(value, byteLength - 1);

  CsafeIntegerWithUnits.fromBytes(Uint8List bytes,
      {Endian inputEndian = Endian.little})
      : unit = CsafeUnitsExtension.fromInt(bytes.last),
        super(
            combineToInt(bytes.sublist(0, bytes.length - 1),
                endian: inputEndian),
            bytes.length - 1);

  bool matchesType(UnitType type) => unit.unitType == type;

  @override
  Uint8List toBytes() {
    return combineTwoLists(super.toBytes(), Uint8List.fromList([unit.value]));
  }

  @override
  List<Object?> get props => [value, unit, _byteLength];
}
