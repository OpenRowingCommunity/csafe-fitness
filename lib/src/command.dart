import 'dart:typed_data';

enum CsafeCommandType { SHORT, LONG }

class CsafeCommand {}

class CsafeCommandIdentifier {
  int identifier;

  CsafeCommandType get type =>
      (identifier >= 0x80) ? CsafeCommandType.SHORT : CsafeCommandType.LONG;

  CsafeCommandIdentifier(this.identifier);
}


class CsafeCommandResponse {}

class CsafeData {
  int byteCount;
  Uint8List data;

  /// Reads in and parses CSAFE data from bytes
  CsafeData.fromBytes(Uint8List bytes)
      : byteCount = bytes.first,
        data = bytes.sublist(1, bytes.first + 1);

  Uint8List toBytes() {
    List<int> dataCopy = data.toList();
    dataCopy.insert(0, dataCopy.length);
    return Uint8List.fromList(dataCopy);
  }
}
