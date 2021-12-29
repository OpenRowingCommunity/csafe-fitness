import 'dart:math';
import 'dart:typed_data';

/// Combines a series of 4 or fewer bytes into a single Dart-native 32-bit integer
int combineToInt(Uint8List data, {endian = Endian.big}) {
  if (data.length > 4) {
    throw FormatException(
        "Cannot combine more than 4 bytes of data into one int");
  }
  List<int> be_value = [];

  if (endian != Endian.big) {
    be_value = data.reversed.toList();
  } else {
    be_value = data.toList();
  }

  int value = 0;
  for (var item in be_value) {
    value = value << 8;
    value |= item;
  }
  return value;
}

/// Combines two byte lists into one by concatenating them together
///
/// This shortcut is useful when serializing multiple commands for example.
Uint8List combineTwoLists(Uint8List data1, Uint8List data2) {
  return Uint8List.fromList(data1.toList() + data2.toList());
}

/// Converts a provided dart [integer] (signed) into a byte representation
///
/// Endianness of the bytes can be specified using [endian]. Defaults to Big Endian (MSB first)
/// [fillBytes] is used to set the length of the output byte list. If the provided integer can be represented in less bytes, the list will be zero-padded to the specified length. The default behavior is that only enough bytes to represent the integer are used i.e. the resulting byte list is as short as possible.
/// An [ArgumentError] is thrown if the [integer] is larger than can be represented by the number of bytes provided by [fillBytes].
Uint8List intToBytes(int integer, {int? fillBytes, endian = Endian.big}) {
  int maxsize = fillBytes ?? 4;
  if (integer > pow(2, 8 * maxsize)) {
    throw ArgumentError(
        "The integer provided is too large to fit within $maxsize bytes");
  }

  List<int> bytes = [];
  bytes.insert(0, integer & 0xFF);

  for (var i = 1; i < 4; i++) {
    int shiftAmt = 8 * i;
    int value = integer >> shiftAmt;
    //TODO: handle unsigned ints
    if ((fillBytes != null && fillBytes > bytes.length) || value > 0) {
      bytes.insert(0, value & 0xFF);
    }
  }

  return Uint8List.fromList(
      (endian == Endian.big) ? bytes : bytes.reversed.toList());
}
