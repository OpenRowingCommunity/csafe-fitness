import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/src/interfaces.dart';

extension CsafeDateExtension on DateTime {
  static DateTime fromBytes(Uint8List bytes) {
    return DateTime(bytes.first + 1900, bytes.elementAt(1), bytes.elementAt(2));
  }

  Uint8List toBytes() {
    return Uint8List.fromList([min((year - 1900), 255), month, day]);
  }
}

extension CsafeTimeExtension on Duration {
  static Duration fromBytes(Uint8List bytes) {
    return Duration(
        hours: bytes.first,
        minutes: bytes.elementAt(1),
        seconds: bytes.elementAt(2));
  }

  /// Validate that this duration rounds to a duration that is between [minSeconds] (inclusive) and [maxSeconds] (exclusive)
  bool lengthIsBetween(int minSeconds, int maxSeconds) {
    var remainingMs =
        inMilliseconds - (inSeconds * Duration.millisecondsPerSecond);
    var secondsCount = remainingMs >= 500 ? inSeconds + 1 : inSeconds;

    return secondsCount >= minSeconds && secondsCount < maxSeconds;
  }

  Uint8List toBytes() {
    int minutes = inMinutes - (inHours * Duration.minutesPerHour);
    int seconds = inSeconds -
        (minutes * Duration.secondsPerMinute) -
        (inHours * Duration.secondsPerHour);
    return Uint8List.fromList([inHours, minutes, seconds]);
  }
}

/// A wrapper class to allow [Uint8List] to effectively implement [ByteSerializable]
///
/// This is literally only used in this one place because every other data type basically builds off of Uint8List anyway
class _CsafeBytes implements ByteSerializable {
  final Uint8List _bytes;

  _CsafeBytes(this._bytes);

  @override
  int get byteLength => _bytes.length;

  @override
  Uint8List toBytes() => _bytes;
}

extension CsafeBytesExtension on Uint8List {
  ByteSerializable asCsafe() => _CsafeBytes(this);
}

extension CsafeDateBytesExtension on DateTime {
  ByteSerializable asCsafe() => toBytes().asCsafe();
}

extension CsafeTimeBytesExtension on Duration {
  ByteSerializable asCsafe() => toBytes().asCsafe();
}

extension CsafeIntExtension on int {
  /// Combines a series of 4 or fewer bytes into a single Dart-native 32-bit integer.
  ///
  /// [endian] specifies how the input data should be interpereted.
  /// Data is returned as a integer in big endian format.
  static int fromBytes(Uint8List data, {endian = Endian.big}) {
    if (data.length > 4) {
      throw FormatException(
          "Cannot combine more than 4 bytes of data into one int");
    }
    List<int> beValue = data.toList();

    if (endian != Endian.big) {
      beValue = data.reversed.toList();
    }

    int value = 0;
    for (var item in beValue) {
      value = value << 8;
      value |= item;
    }
    return value;
  }

  /// Converts a provided dart [integer] (signed) into a byte representation
  ///
  /// Endianness of the bytes can be specified using [endian]. Defaults to Big Endian (MSB first)
  /// [fillBytes] is used to set the length of the output byte list. If the provided integer can be represented in less bytes, the list will be zero-padded to the specified length. The default behavior is that only enough bytes to represent the integer are used i.e. the resulting byte list is as short as possible.
  /// An [ArgumentError] is thrown if the [integer] is larger than can be represented by the number of bytes provided by [fillBytes].
  Uint8List toBytes({int? fillBytes, endian = Endian.big}) {
    int maxsize = fillBytes ?? 4;
    if (this > pow(2, 8 * maxsize)) {
      throw ArgumentError(
          "The integer provided is too large to fit within $maxsize bytes");
    }

    List<int> bytes = [];
    bytes.insert(0, this & 0xFF);

    for (var i = 1; i < 4; i++) {
      int shiftAmt = 8 * i;
      int value = this >> shiftAmt;
      //TODO: handle unsigned ints?
      if ((fillBytes != null && fillBytes > bytes.length) || value > 0) {
        bytes.insert(0, value & 0xFF);
      }
    }

    return Uint8List.fromList(
        (endian == Endian.big) ? bytes : bytes.reversed.toList());
  }
}
