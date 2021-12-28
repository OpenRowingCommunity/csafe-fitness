import 'dart:typed_data';

abstract class ByteSerializable {
  int get byteLength => toBytes().length;

  Uint8List toBytes();
}
