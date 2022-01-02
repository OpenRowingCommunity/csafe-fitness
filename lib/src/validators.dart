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
      (data) => (data.byteLength == expectedLength),
      (data) => ArgumentError(
          "Data is not the correct length. Expected: $expectedLength bytes, Received: ${data.byteLength} bytes"));
}

/// Shortcut for a validator to assert that the data has a specific type
Validator validateType<T>() {
  return validate(
      (data) => (data is T),
      (data) => ArgumentError(
          "Data is not the correct type. Expected ${T.runtimeType}"));
}

/// Shortcut for a validator to assert that the data is a unit with a specific type (i.e. distance, force)
Validator validateUnitType(UnitType expectedType) {
  return validate(
      (data) =>
          (data is CsafeIntegerWithUnits && data.matchesType(expectedType)),
      (data) => (data is CsafeIntegerWithUnits)
          ? ArgumentError(
              "Incorrect Units Provided. Expected units of ${expectedType.toString()}, received units of ${data.unit.unitType}")
          : ArgumentError("Provided Data is not a CsafeIntegerWithUnits type"));
}

/// Shortcut for a validator to assert that the data is a single byte equal to 1 or 0
Validator validateBoolean() {
  return validate(
      (bytes) =>
          bytes.byteLength == 1 &&
          (bytes.toBytes().first == 0 || bytes.toBytes().first == 1),
      (bytes) => ArgumentError(
          "Provided data is not a a single byte equal to 1 or 0."));
}

/// Shortcut for a validator to assert that the data represents a [CsafeDate]
Validator validateCsafeDate() {
  return validate(
      (bytes) => bytes.byteLength == 3 || bytes is DateTime,
      (bytes) => ArgumentError(
          "Provided date value is not a DateTime or 3-byte data field"));
}

/// Shortcut for a validator to assert that the data represents a [CsafeTime]
Validator validateCsafeTime() {
  return validate(
      (bytes) => bytes.byteLength == 3 || bytes is Duration,
      (bytes) => ArgumentError(
          "Provided time value is not a Duration or 3-byte data field"));
}
