import 'dart:typed_data';

enum CsafeCommandType { short, long }

class CsafeCommand {}

class CsafeCommandIdentifier {
  int identifier;

  CsafeCommandType get type =>
      (identifier >= 0x80) ? CsafeCommandType.short : CsafeCommandType.long;

  CsafeCommandIdentifier(this.identifier);
}


class CsafeCommandResponse {}

class CsafeDataStructure {
  int byteCount;
  Uint8List data;

  /// Reads in and parses CSAFE data from bytes
  CsafeDataStructure.fromBytes(Uint8List bytes)
      : byteCount = bytes.first,
        data = bytes.sublist(1, bytes.first + 1);

  Uint8List toBytes() {
    List<int> dataCopy = data.toList();
    dataCopy.insert(0, dataCopy.length);
    return Uint8List.fromList(dataCopy);
  }
}
