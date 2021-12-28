import 'package:csafe_fitness/src/interfaces.dart';
import 'package:csafe_fitness/src/types/extensions.dart';
import 'package:equatable/equatable.dart';

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
