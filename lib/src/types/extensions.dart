import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/src/interfaces.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';

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
