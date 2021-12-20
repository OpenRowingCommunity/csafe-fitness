import 'dart:typed_data';

/// Combines a series of 4 or fewer bytes into a single Dart-native 32-bit integer
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

/// Combines two byte lists into one by concatenating them together
///
/// This shortcut is useful when serializing multiple commands for example.
Uint8List combineTwoLists(Uint8List data1, Uint8List data2) {
  return Uint8List.fromList(data1.toList() + data2.toList());
}
