import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:csafe_fitness/src/interfaces.dart';
import 'extensions.dart';
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

/// Represents an Integer with an associated unit.
///
/// By itself this is not designed to work with the CSAFE spec and exists to provide an interface for other libraries (such as for concept2 machines) to build their own unit types to send via CSAFE
abstract class IntegerWithUnits<T> extends Equatable
    implements ByteSerializable {
  final int value;
  final int _byteLength;
  final T unit;
  // final Endian endian = Endian.little;

  @override
  int get byteLength => _byteLength;

  IntegerWithUnits(this.value, this.unit, this._byteLength);

  @override
  List<Object?> get props => [value, unit, _byteLength];
}

/// Represents a "Integer plus Unit specifier" type from the CSAFE spec
///
/// This builds on top of [IntegerWithUnits] by adding shortcuts for different common units, a concrete implementation of toBytes and other helper methods
class CsafeIntegerWithUnits extends IntegerWithUnits<CsafeUnits> {
  CsafeIntegerWithUnits(value, unit, {int byteLength = 3})
      : super(value, unit, byteLength);

  CsafeIntegerWithUnits.meters(value, {int byteLength = 3})
      : super(value, CsafeUnits.meter, byteLength);

  CsafeIntegerWithUnits.kilometers(value, {int byteLength = 3})
      : super(value, CsafeUnits.kilometer, byteLength);

  CsafeIntegerWithUnits.watts(value, {int byteLength = 3})
      : super(value, CsafeUnits.watts, byteLength);

  CsafeIntegerWithUnits.fromBytes(Uint8List bytes,
      {Endian inputEndian = Endian.little})
      : super(
            CsafeIntExtension.fromBytes(bytes.sublist(0, bytes.length - 1),
                endian: inputEndian),
            CsafeUnitsExtension.fromInt(bytes.last),
            bytes.length);

  bool matchesType(UnitType type) => unit.unitType == type;

  @override
  Uint8List toBytes() {
    //3.2.1 General conventions: All integers are sent low byte first and are considered unsigned integers unless otherwise specified.
    return combineTwoLists(
        value.toBytes(fillBytes: _byteLength - 1, endian: Endian.little),
        Uint8List.fromList([unit.value]));
  }
}
