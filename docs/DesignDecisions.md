
# Design Decisions

## Why was this library developed?

his library was originally developed to support a flutter Bluetooth library for Concept2 fitness equipment. However, because many other fitness equipment manufacturers are likely to use CSAFE, it seeemed like a useful thing to break out into a separate dart-only library in case someone else is able to make use of it for a different project supporting different fitness equipment.



## Parameter Validation

While a validation method that allows compile-time type checking would be preferred, the current system uses the `ByteSerializable` interface as a representation of data and combines this with `Validator` functions that can be run on this data to make sure it is valid before allowing the construction of a `CsafeCommand`.

