import 'dart:typed_data';

/// Combines two byte lists into one by concatenating them together
///
/// This shortcut is useful when serializing multiple commands for example.
Uint8List combineTwoLists(Uint8List data1, Uint8List data2) {
  return Uint8List.fromList(data1.toList() + data2.toList());
}
