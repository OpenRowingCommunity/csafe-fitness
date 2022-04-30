
# API

This document aims to lay out some of the high and mid-level design concepts behing the public facing API for csafe-fitness.

Internal API and workings are documented in [internals](internals.md)


## Parameter Validation

While a validation method that allows compile-time type checking would be preferred, the current system uses the `ByteSerializable` interface as a representation of data and combines this with `Validator` functions that can be run on this data to make sure it is valid before allowing the construction of a `CsafeCommand`.



## Extensions

where it makes sense, this libary adds extensions to common dart types, such as DateTime, Duration, and Uint8List to allow them to be passed into functions that accept `ByteSerializable` values. These extentions will likely have a method like `asCsafe()` that converts them to a compatible type. Kinda kludgy but simple and works well enough.

