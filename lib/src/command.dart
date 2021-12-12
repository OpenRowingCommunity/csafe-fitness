import 'dart:typed_data';

class CsafeCommand {}

class CsafeLongCommand {}

class CsafeShortCommand {}

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
