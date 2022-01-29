import 'dart:typed_data';

/// A simple interface representing anything that can be turned into bytes
///
/// This is used pretty much everywhere within this library
abstract class ByteSerializable {
  int get byteLength => toBytes().length;

  Uint8List toBytes();
}
