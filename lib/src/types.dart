enum CsafeCommandType { short, long }

enum CsafePreviousFrameState { ok, reject, bad, notReady }

extension CsafePreviousFrameStateExtension on CsafePreviousFrameState {
  int get value => index;
  static CsafePreviousFrameState fromInt(int i) =>
      CsafePreviousFrameState.values[i];
}

enum CsafeServerState {
  error,
  ready,
  idle,
  haveID,
  inUse,
  paused,
  finished,
  manual,
  offline
}

extension CsafeServerStateExtension on CsafeServerState {
  int get value {
    switch (this) {
      case CsafeServerState.error:
      case CsafeServerState.ready:
      case CsafeServerState.idle:
      case CsafeServerState.haveID:
        return index;
      case CsafeServerState.inUse:
        return 5;
      case CsafeServerState.paused:
        return 6;
      case CsafeServerState.finished:
        return 7;
      case CsafeServerState.manual:
        return 8;
      case CsafeServerState.offline:
        return 9;
    }
  }

  static CsafeServerState fromInt(int i) {
    switch (i) {
      case 0:
        return CsafeServerState.error;
      case 1:
        return CsafeServerState.ready;
      case 2:
        return CsafeServerState.idle;
      case 3:
        return CsafeServerState.haveID;
      case 5:
        return CsafeServerState.inUse;
      case 6:
        return CsafeServerState.paused;
      case 7:
        return CsafeServerState.finished;
      case 8:
        return CsafeServerState.manual;
      case 9:
        return CsafeServerState.offline;
      default:
        throw FormatException("value $i has no matching CsafeServerState");
    }
  }
}
