import 'dart:typed_data';

/// An implementation of the CSAFE framing protocol
///
/// 2.2 This "Frame Protocol is designed to transport data without regard to the meaning of the data"
class CsafeFrame {
  static final CsafeFrame empty = CsafeFrame(Uint8List(0));

  static const int standardStartFlag = 0xF1;
  static const int standardStopFlag = 0xF2;
  Uint8List frameContents = Uint8List(0);

  ///1 byte XOR of all bytes in Frame Contents.
  int? _checksum;

  int get checksum => _checksum ?? _calculateChecksum();

  CsafeFrame(this.frameContents, [this._checksum]);

  CsafeFrame.fromBytes(Uint8List contents)
      : frameContents = contents.sublist(0, contents.length - 1),
        _checksum = contents.last;

  /// Decodes frame contents from bytes and converts any escaped sequences back to a single byte
  ///
  /// This comes from section 2.1.2 of the CSAFE Framework Spec:
  /// "To make the receiving software simple, we must ensure that the unique Start and Stop flag bytes never appear in the Frame Contents or in the Checksum. If we do this, the detection of the Start or Stop flag in the byte stream has an unambiguous meaning, i.e. the beginning or the end of a frame. This is accomplished by a "byte-stuffing" technique that transforms any of the four bytes of the form 111100xx (binary), i.e. F0, F1,F2 and F3 hex, into the two byte sequence 11110011 000000xx. For example, the Start Flag, F1 hex, if found somewhere in the Frame Contents, would be converted into the two-byte sequence: F3, 01 hex when it was transmitted. Hence the Start and Stop Flag bytes can never occur in the final byte stream transmitted except at the beginning and end of the frame and we will have accomplished our goal of reserving the Start and Stop Flag values to appear only at the ends of the frame."
  CsafeFrame.fromEncodedBytes(Uint8List encodedContents) {
    List<int> list = encodedContents.toList();
    List<int> newList = [];
    // remove any start and stop flags
    if (list.first == CsafeFrame.standardStartFlag) {
      list.removeAt(0);
    }
    if (list.last == CsafeFrame.standardStopFlag) {
      list.removeAt(list.length - 1);
    }

    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      var last = (i > 0) ? list[i - 1] : list[0];
      if (item <= 3 && last == 0xF3) {
        // or the current byte with F0 to reconstruct the non-escaped value
        newList.add(0xF0 | item);
      } else {
        newList.add(item);
      }
    }

    Uint8List frameBody = Uint8List.fromList(newList);

    CsafeFrame(frameBody.sublist(0, frameBody.length - 1), frameBody.last);
  }

  /// Escapes any start and stop flags found within the contents to gaurantee that they only appear once in each frame
  Uint8List toBytes() {
    List<int> list = frameContents.toList();
    list.add(checksum);
    List<int> newList = [];

    newList.add(CsafeFrame.standardStartFlag);

    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      if (item >= 0xF0 && item <= 0xF3) {
        // these bytes conflict with the start and stop byte, so escape them to two bytes
        newList.add(0xF3);
        newList.add(item & 0x3); //only take the lower two bits
      } else {
        newList.add(item);
      }
    }
    newList.add(CsafeFrame.standardStopFlag);

    return Uint8List.fromList(newList);
  }

  /// validate that the checksum and frameContents are consistent with each other
  bool validate() {
    return _calculateChecksum() == checksum;
  }

  int _calculateChecksum() {
    // 1 byte XOR of all bytes in Frame Contents. When calculating the checksum for a frame, a starting value of 0 is used.
    int calculatedChecksum = 0;

    if (frameContents.isEmpty) {
      return 0;
    }

    for (var byte in frameContents) {
      calculatedChecksum ^= byte;
    }
    return calculatedChecksum;
  }
}
