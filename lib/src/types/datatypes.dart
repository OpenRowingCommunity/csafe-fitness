import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
import 'package:csafe_fitness/src/interfaces.dart';
import 'package:csafe_fitness/src/types/extensions.dart';
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

  int toByte() {
    return identifier;
  }

  @override
  List<Object> get props => [identifier];
}

/// A placeholder for some number of bytes.
///
/// This is used by the [CsafeLongCommandFactory] to allow the legth and type/validation for data to be set in advance so the user/implementer can provide a value without caring about most if not all of the validation involved
///
/// This is the base type that is extended by other Placeholder classes that provide additional validation
class CsafePlaceholder extends Equatable {
  final int byteLength;

  CsafePlaceholder(this.byteLength);

  bool accepts(ByteSerializable value) => value.byteLength == byteLength;

  @override
  List<Object?> get props => [byteLength];
}

/// Represents a "Integer plus Unit specifier" type from the CSAFE spec
class CsafeIntegerWithUnits extends Equatable implements ByteSerializable {
  int value;
  CsafeUnits unit;

  @override
  int get byteLength => toBytes().length;

  CsafeIntegerWithUnits(this.value, this.unit);

  CsafeIntegerWithUnits.fromBytes(Uint8List bytes)
      : value = combineToInt(bytes.sublist(0, bytes.length - 1)),
        unit = CsafeUnitsExtension.fromInt(bytes.last);

  bool matchesType(UnitType type) => unit.unitType == type;

  @override
  Uint8List toBytes() {
    return Uint8List.fromList(
        intToBytes(value) + Uint8List.fromList([unit.value]));
  }

  @override
  List<Object?> get props => [value, unit];
}

/// Represents a placeholder for a [CsafeIntegerWithUnits] value that will be provided by the user in the future
///
/// This type is essentially a wrapper over [CsafePlaceholder] with additional validation to help ensure that values provided will match what is expected by the device being communicated with
class CsafeIntegerWithUnitsPlaceholder extends CsafePlaceholder {
  UnitType unitType;

  CsafeIntegerWithUnitsPlaceholder(int byteLength, this.unitType)
      : super(byteLength);

  @override
  bool accepts(ByteSerializable value) {
    return super.accepts(value) &&
        value is CsafeIntegerWithUnits &&
        value.matchesType(unitType);
  }

  @override
  List<Object?> get props => [byteLength, unitType];
}

/// A placeholder for a csafe Time type
class CsafeTimePlaceholder extends CsafePlaceholder {
  CsafeTimePlaceholder() : super(3);

  @override
  bool accepts(ByteSerializable value) {
    return super.accepts(value) && value is Duration;
  }
}

/// A placeholder for a csafe Date type
class CsafeDatePlaceholder extends CsafePlaceholder {
  CsafeDatePlaceholder() : super(3);

  @override
  bool accepts(ByteSerializable value) {
    return super.accepts(value) && value is DateTime;
  }
}
