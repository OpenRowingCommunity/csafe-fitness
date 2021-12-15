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

enum CsafeUnits {
  mile,
  tenthMile,
  hundredthMile,
  thousandthMile,
  feet,
  inch,
  pounds,
  tenthPounds,
  tenFeet,
  milePerHour,
  tenthMilePerHour,
  hundredthMilePerHour,
  feetPerMinute,
  kilometer,
  tenthKilometer,
  hundredthKilometer,
  meter,
  tenthMeter,
  centimeter,
  kilogram,
  tenthKilogram,
  kilometerPerHour,
  tenthKilometerPerHour,
  hundredthKimometerPerHour,
  meterPerMinute,
  minutesPerMile,
  minutesPerKilometer,
  secondsPerKilometer,
  secondsPerMile,
  floors,
  tenthFloors,
  steps,
  revolutions,
  strides,
  strokes,
  beats,
  calories,
  kp, //suspect this may be a kilopound, but not sure enough to make that the name
  percentGrade,
  hundredthPercentGrade,
  tenthPercentGrade,
  tenthFloorsPerMinute,
  floorsPerMinute,
  stepsPerMinute,
  revolutionsPerMinute,
  stridesPerMinute,
  strokesPerMinute,
  beatsPerMinute,
  caloriesPerMinute,
  caloriesPerHour,
  watts,
  kpm, //suspect kilopond-meter
  inchPound,
  footPound,
  newtonMeters,
  amperes,
  thousandthAmperes,
  volts,
  thousandthVolts
}

extension CsafeUnitsExtension on CsafeUnits {
  int get value {
    switch (this) {
      case CsafeUnits.mile:
        return 1;
      case CsafeUnits.tenthMile:
        return 2;
      case CsafeUnits.hundredthMile:
        return 3;
      case CsafeUnits.thousandthMile:
        return 4;
      case CsafeUnits.feet:
        return 5;
      case CsafeUnits.inch:
        return 6;
      case CsafeUnits.pounds:
        return 7;
      case CsafeUnits.tenthPounds:
        return 8;
      case CsafeUnits.tenFeet:
        return 10;
      case CsafeUnits.milePerHour:
        return 16;
      case CsafeUnits.tenthMilePerHour:
        return 17;
      case CsafeUnits.hundredthMilePerHour:
        return 18;
      case CsafeUnits.feetPerMinute:
        return 19;
      case CsafeUnits.kilometer:
        return 33;
      case CsafeUnits.tenthKilometer:
        return 34;
      case CsafeUnits.hundredthKilometer:
        return 35;
      case CsafeUnits.meter:
        return 36;
      case CsafeUnits.tenthMeter:
        return 37;
      case CsafeUnits.centimeter:
        return 38;
      case CsafeUnits.kilogram:
        return 39;
      case CsafeUnits.tenthKilogram:
        return 40;
      case CsafeUnits.kilometerPerHour:
        return 48;
      case CsafeUnits.tenthKilometerPerHour:
        return 49;
      case CsafeUnits.hundredthKimometerPerHour:
        return 50;
      case CsafeUnits.meterPerMinute:
        return 51;
      case CsafeUnits.minutesPerMile:
        return 55;
      case CsafeUnits.minutesPerKilometer:
        return 56;
      case CsafeUnits.secondsPerKilometer:
        return 57;
      case CsafeUnits.secondsPerMile:
        return 58;
      case CsafeUnits.floors:
        return 65;
      case CsafeUnits.tenthFloors:
        return 66;
      case CsafeUnits.steps:
        return 67;
      case CsafeUnits.revolutions:
        return 68;
      case CsafeUnits.strides:
        return 69;
      case CsafeUnits.strokes:
        return 70;
      case CsafeUnits.beats:
        return 71;
      case CsafeUnits.calories:
        return 72;
      case CsafeUnits.kp:
        return 73;
      case CsafeUnits.percentGrade:
        return 74;
      case CsafeUnits.hundredthPercentGrade:
        return 75;
      case CsafeUnits.tenthPercentGrade:
        return 76;
      case CsafeUnits.tenthFloorsPerMinute:
        return 79;
      case CsafeUnits.floorsPerMinute:
        return 80;
      case CsafeUnits.stepsPerMinute:
        return 81;
      case CsafeUnits.revolutionsPerMinute:
        return 82;
      case CsafeUnits.stridesPerMinute:
        return 83;
      case CsafeUnits.strokesPerMinute:
        return 84;
      case CsafeUnits.beatsPerMinute:
        return 85;
      case CsafeUnits.caloriesPerMinute:
        return 86;
      case CsafeUnits.caloriesPerHour:
        return 87;
      case CsafeUnits.watts:
        return 88;
      case CsafeUnits.kpm:
        return 89;
      case CsafeUnits.inchPound:
        return 90;
      case CsafeUnits.footPound:
        return 91;
      case CsafeUnits.newtonMeters:
        return 92;
      case CsafeUnits.amperes:
        return 97;
      case CsafeUnits.thousandthAmperes:
        return 98;
      case CsafeUnits.volts:
        return 99;
      case CsafeUnits.thousandthVolts:
        return 100;
    }
  }

  static CsafeUnits fromInt(int i) {
    switch (i) {
      case 1:
        return CsafeUnits.mile;
      case 2:
        return CsafeUnits.tenthMile;
      case 3:
        return CsafeUnits.hundredthMile;
      case 4:
        return CsafeUnits.thousandthMile;
      case 5:
        return CsafeUnits.feet;
      case 6:
        return CsafeUnits.inch;
      case 7:
        return CsafeUnits.pounds;
      case 8:
        return CsafeUnits.tenthPounds;
      case 10:
        return CsafeUnits.tenFeet;
      case 16:
        return CsafeUnits.milePerHour;
      case 17:
        return CsafeUnits.tenthMilePerHour;
      case 18:
        return CsafeUnits.hundredthMilePerHour;
      case 19:
        return CsafeUnits.feetPerMinute;
      case 33:
        return CsafeUnits.kilometer;
      case 34:
        return CsafeUnits.tenthKilometer;
      case 35:
        return CsafeUnits.hundredthKilometer;
      case 36:
        return CsafeUnits.meter;
      case 37:
        return CsafeUnits.tenthMeter;
      case 38:
        return CsafeUnits.centimeter;
      case 39:
        return CsafeUnits.kilogram;
      case 40:
        return CsafeUnits.tenthKilogram;
      case 48:
        return CsafeUnits.kilometerPerHour;
      case 49:
        return CsafeUnits.tenthKilometerPerHour;
      case 50:
        return CsafeUnits.hundredthKimometerPerHour;
      case 51:
        return CsafeUnits.meterPerMinute;
      case 55:
        return CsafeUnits.minutesPerMile;
      case 56:
        return CsafeUnits.minutesPerKilometer;
      case 57:
        return CsafeUnits.secondsPerKilometer;
      case 58:
        return CsafeUnits.secondsPerMile;
      case 65:
        return CsafeUnits.floors;
      case 66:
        return CsafeUnits.tenthFloors;
      case 67:
        return CsafeUnits.steps;
      case 68:
        return CsafeUnits.revolutions;
      case 69:
        return CsafeUnits.strides;
      case 70:
        return CsafeUnits.strokes;
      case 71:
        return CsafeUnits.beats;
      case 72:
        return CsafeUnits.calories;
      case 73:
        return CsafeUnits.kp;
      case 74:
        return CsafeUnits.percentGrade;
      case 75:
        return CsafeUnits.hundredthPercentGrade;
      case 76:
        return CsafeUnits.tenthPercentGrade;
      case 79:
        return CsafeUnits.tenthFloorsPerMinute;
      case 80:
        return CsafeUnits.floorsPerMinute;
      case 81:
        return CsafeUnits.stepsPerMinute;
      case 82:
        return CsafeUnits.revolutionsPerMinute;
      case 83:
        return CsafeUnits.stridesPerMinute;
      case 84:
        return CsafeUnits.strokesPerMinute;
      case 85:
        return CsafeUnits.beatsPerMinute;
      case 86:
        return CsafeUnits.caloriesPerMinute;
      case 87:
        return CsafeUnits.caloriesPerHour;
      case 88:
        return CsafeUnits.watts;
      case 89:
        return CsafeUnits.kpm;
      case 90:
        return CsafeUnits.inchPound;
      case 91:
        return CsafeUnits.footPound;
      case 92:
        return CsafeUnits.newtonMeters;
      case 97:
        return CsafeUnits.amperes;
      case 98:
        return CsafeUnits.thousandthAmperes;
      case 99:
        return CsafeUnits.volts;
      case 100:
        return CsafeUnits.thousandthVolts;
      default:
        throw FormatException("value $i has no matching CsafeUnits value");
    }
  }
}
