import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/src/helpers.dart';
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
/// This is used by the [CsafeLongCommandFactory] to allow the amount and type of data provided as a parameter to be set in advance so the user/implementer doesnt have to care, while still allowing the user to set their own value
///
/// This is the base type that is extended by other Csafe______Placeholder classes
class CsafeBytesPlaceholder extends Equatable {
  final int byteLength;
  Uint8List? _bytes;
  Uint8List? get bytes => _bytes;
  set bytes(Uint8List? newBytes) {
    if (newBytes != null && newBytes.length == byteLength) {
      _bytes = newBytes;
    }
  }

  bool get isFilled => bytes != null;

  CsafeBytesPlaceholder(this.byteLength);

  CsafeBytesPlaceholder.withValue(this.byteLength, this._bytes) {
    if (bytes!.length > byteLength) {
      //TODO: how to handle this
    }
  }

  bool validate({shouldThrow: false}) {
    try {
      if (!isFilled) {
        throw Exception(
            "Empty Placeholder value must be filled before being used");
      }
    } catch (e) {
      if (shouldThrow) {
        rethrow;
      }
      return false;
    }
    return true;
  }

  Uint8List toBytes() {
    validate(shouldThrow: true);
    // TODO: somehow limit the byte size in case its too big
    return bytes!;
  }

  @override
  List<Object?> get props => [byteLength];
}

/// Represents a "Integer plus Unit specifier" type from the CSAFE spec
class CsafeIntegerWithUnits extends Equatable {
  int value;
  CsafeUnits unit;

  CsafeIntegerWithUnits(this.value, this.unit);

  CsafeIntegerWithUnits.fromBytes(Uint8List bytes)
      : value = combineToInt(bytes.sublist(0, bytes.length - 1)),
        unit = CsafeUnitsExtension.fromInt(bytes.last);

  bool matchesType(CsafeUnits unit) => this.unit.unitType == unit.unitType;

  Uint8List toBytes() {
    return Uint8List.fromList(
        intToBytes(value) + Uint8List.fromList([unit.value]));
  }

  @override
  List<Object?> get props => [value, unit];
}

/// Represents a placeholder for a [CsafeIntegerWithUnits] value that will be provided by the user in the future
///
/// This type is essentially a wrapper over [CsafeBytesPlaceholder] with additional validation to help ensure that values provided will match what is expected by the device being communicated with
class CsafeIntegerWithUnitsPlaceholder extends CsafeBytesPlaceholder {
  UnitType unitType;

  CsafeUnits? unit;
  int? get integer => (isFilled) ? combineToInt(bytes!) : null;

  set integer(int? newInt) {
    if (newInt != null) {
      // newInt = newInt
      Uint8List byteList = intToBytes(newInt);
      _bytes = byteList.sublist(
          max(0, byteList.length - byteLength - 1), byteList.length);
    }
  }

  CsafeIntegerWithUnitsPlaceholder(int byteLength, this.unitType)
      : super(byteLength);

  CsafeIntegerWithUnitsPlaceholder.withValue(
      int integer, int byteLength, this.unitType)
      : super(byteLength) {
    this.integer = integer;
  }

  CsafeIntegerWithUnitsPlaceholder.fromBytes(Uint8List bytes)
      : unit = CsafeUnitsExtension.fromInt(bytes.last),
        unitType = CsafeUnitsExtension.fromInt(bytes.last).unitType,
        super.withValue(bytes.length, bytes.sublist(0, bytes.length - 1));

  @override
  List<Object?> get props => [byteLength, unit];

  @override
  Uint8List toBytes() {
    super.validate(shouldThrow: true);

    if ((byteLength - 1) < 4) {
      integer = integer! & 0xFFFF;
    }

    Uint8List outBytes =
        combineTwoLists(_bytes!, Uint8List.fromList([unit!.value]));
    return outBytes;
  }

  // define some shortcut constructors for creating instances from the most common units.
}

/// Represents a csafe Time type
class CsafeTimePlaceholder extends CsafeBytesPlaceholder {
  Duration? get time =>
      (isFilled) ? CsafeTimeExtension.fromBytes(_bytes!) : null;

  set time(Duration? newTime) {
    if (newTime != null) {
      _bytes = newTime.toBytes();
    }
  }

  CsafeTimePlaceholder() : super(3);

  CsafeTimePlaceholder.withValue(Duration time) : super(3) {
    this.time = time;
  }

  CsafeTimePlaceholder.fromBytes(Uint8List bytes) : super.withValue(3, bytes);

  @override
  List<Object?> get props => [byteLength];
}

/// Represents a csafe Date type
class CsafeDatePlaceholder extends CsafeBytesPlaceholder {
  DateTime? get date =>
      (isFilled) ? CsafeDateExtension.fromBytes(_bytes!) : null;

  set date(DateTime? newTime) {
    if (newTime != null) {
      _bytes = newTime.toBytes();
    }
  }

  CsafeDatePlaceholder() : super(3);

  CsafeDatePlaceholder.withValue(DateTime date) : super(3) {
    this.date = date;
  }

  CsafeDatePlaceholder.fromBytes(Uint8List bytes) : super.withValue(3, bytes);

  @override
  List<Object?> get props => [byteLength];
}
