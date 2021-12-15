import 'dart:typed_data';

int combineToInt(Uint8List data) {
  if (data.length > 4) {
    throw FormatException(
        "Cannot combine more than 4 bytes of data into one int");
  }
  int value = 0;
  for (var item in data) {
    value = value << 8;
    value |= item;
  }
  return value;
}
