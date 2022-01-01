/// This file contains functions that return functions to validate that data conforms to particular requirements
///
/// These are used by subclasses of [CsafeCommand] for validating input
import 'interfaces.dart';
import 'types/enumtypes.dart';

import 'types/datatypes.dart';

/// Creates a validator function
///
/// [condition] is a function that takes a [ByteSerializable] and returns the boolean result of the validation condition
/// [error] is a function taking a [ByteSerializable] that generates an error to be thrown in the event that the condition fails and the caller wanted the validator to throw an exception with a detailed error message. This allows the error message to contain variables derived from the value being validated.
Validator validate(bool Function(ByteSerializable) condition,
    Error Function(ByteSerializable) error) {
  return (ByteSerializable data, {bool shouldThrow = false}) {
    if (condition(data)) return true;
    return (shouldThrow) ? throw error(data) : false;
  };
}

/// Shortcut for a validator to assert that the data has a specific length
Validator validateLength(int expectedLength) {
  return validate(
      (data) => (data.byteLength == expectedLength), ArgumentError(""));
}

/// Shortcut for a validator to assert that the data has a specific type
Validator validateType<T>() {
  return validate((data) => (data is T), ArgumentError(""));
}

/// Shortcut for a validator to assert that the data is a unit with a specific type (i.e. distance, force)
Validator validateUnitType(UnitType expectedType) {
  return validate(
      (data) =>
          (data is CsafeIntegerWithUnits && data.unit.unitType == expectedType),
      ArgumentError(""));
}
