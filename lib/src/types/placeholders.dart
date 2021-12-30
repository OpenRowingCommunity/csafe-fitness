import 'package:csafe_fitness/src/interfaces.dart';
import 'package:equatable/equatable.dart';

import 'datatypes.dart';
import 'enumtypes.dart';

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

///A placeholder that does no validation, useful for custom data of an unspecified length
class CsafeCustomPlaceholder extends CsafePlaceholder {
  CsafeCustomPlaceholder() : super(0);

  @override
  bool accepts(ByteSerializable value) => true;
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
}

/// A placeholder for a csafe Date type
class CsafeDatePlaceholder extends CsafePlaceholder {
  CsafeDatePlaceholder() : super(3);
}

/// A placeholder for a csafe Logical type representing true or false
class CsafeBooleanPlaceholder extends CsafePlaceholder {
  CsafeBooleanPlaceholder() : super(1);

  @override
  bool accepts(ByteSerializable value) {
    int byte = value.toBytes().first;
    return super.accepts(value) && (byte == 0 || byte == 1);
  }
}
