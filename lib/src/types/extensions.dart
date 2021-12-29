import 'dart:math';
import 'dart:typed_data';

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

extension CsafeBytesExtension on Uint8List {
  CsafeBytes asCsafe() => CsafeBytes(this);
}

extension CsafeDateBytesExtension on DateTime {
  CsafeBytes asCsafe() => CsafeBytes(toBytes());
}

extension CsafeTimeBytesExtension on Duration {
  CsafeBytes asCsafe() => CsafeBytes(toBytes());
}
