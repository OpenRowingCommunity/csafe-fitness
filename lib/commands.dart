import 'package:csafe_fitness/src/interfaces.dart';
import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/enumtypes.dart';
import 'package:csafe_fitness/src/validators.dart';

///go to Idle State, reset variables to Idle state
CsafeCommand cmdGoIdle = CsafeCommand.short(0x82);

///go to InUse State
CsafeCommand cmdGoInUse = CsafeCommand.short(0x85);

///go to Finished State
CsafeCommand cmdGoFinished = CsafeCommand.short(0x86);

///go to Ready State
CsafeCommand cmdGoReady = CsafeCommand.short(0x87);

///Horizontal distance goal
///
/// Data interpereted as Integer plus Unit* specifier
class CsafeCmdSetHorizontal extends CsafeCommand {
  CsafeCmdSetHorizontal(ByteSerializable data) : super.long(0x21, 3, data) {
    validateData(data, [validateUnitType(UnitType.distance)],
        shouldThrow: true);
  }
}

/// Set current time of day
///
/// Data interpereted as Time*
class CsafeCmdSetTIme extends CsafeCommand {
  CsafeCmdSetTIme(ByteSerializable data) : super.long(0x11, 3, data) {
    validateData(data, [validateCsafeTime()], shouldThrow: true);
  }
}

/// Set current date.
///
/// Data interpereted as Date*
class CsafeCmdSetDate extends CsafeCommand {
  CsafeCmdSetDate(ByteSerializable data) : super.long(0x12, 3, data) {
    validateData(data, [validateCsafeDate()], shouldThrow: true);
  }
}

/// Server depended configuration information
///
/// Data interpereted as Custom
class CsafeCmdUserCfg1 extends CsafeCommand {
  CsafeCmdUserCfg1(ByteSerializable data) : super.long(0x1A, null, data);
}

///Machine program and level
///
/// Data interpereted as Byte (program), Byte (level)
class CsafeCmdSetProgram extends CsafeCommand {
  CsafeCmdSetProgram(ByteSerializable data) : super.long(0x24, 2, data);
}

/// Power goal
///
/// Data Interpereted as Integer plus Unit* specifier
class CsafeCmdSetPower extends CsafeCommand {
  CsafeCmdSetPower(ByteSerializable data) : super.long(0x34, 3, data) {
    validateData(data, [validateUnitType(UnitType.power)], shouldThrow: true);
  }
}

/*

class CsafePredefinedCommands {
  ///Request Status from Server.
  ///
  ///Status is sent even if the flgAck flag is off, i.e. this command can be added to a frame to force an acknowledgment of the frame even it the flgAck is off. Unlike the "Empty Frame" this command does update the Status.
  static CsafeCommand cmdGetStatus = CsafeCommand.short(0x80);

  ///Reset Server.
  ///
  ///Initialize variables to Ready State and reset Frame Toggle and Status of Previous Frame flag to zero.
  static CsafeCommand cmdReset = CsafeCommand.short(0x81);

  ///go to HaveID state
  static CsafeCommand cmdGoHaveID = CsafeCommand.short(0x83);

  ///Indicates to Server that the user ID entered was invalid
  static CsafeCommand cmdBadID = CsafeCommand.short(0x88);

  // ///Control automatic upload features. See table below for definition.
  // CsafeCommand cmdAutoUpload = CsafeLongCommand.fromByte(0x01);

  // ///List of commands that specify data for batched upload. *
  // CsafeCommand cmdUpList = CsafeLongCommand.fromByte(0x02);

  // ///Interval between periodic automatic uploads of status **
  // CsafeCommand cmdUpStatusSec = CsafeLongCommand.fromByte(0x04);

  // ///Interval between periodic automatic uploads of UpList
  // CsafeCommand cmdUpListSec = CsafeLongCommand.fromByte(0x05);

  /// An integer between 2 - 5 defining the number of digits to accept from the user as a valid ID
  ///
  /// data interpereted as byte
  static CsafeLongCommandFactory cmdIDDigits =
      CsafeLongCommandFactory(0x10, CsafePlaceholder(1));

  

  /// Set timeout period for exiting certain states. See state diagram for details.
  ///
  /// Data interpereted as Seconds
  static CsafeLongCommandFactory cmdSetTimeout =
      CsafeLongCommandFactory(0x13, CsafePlaceholder(1));

  

  /// Server depended configuration information
  ///
  /// Data interpereted as Custom
  static CsafeLongCommandFactory cmdUserCfg2 =
      CsafeLongCommandFactory(0x1B, CsafeCustomPlaceholder());

  /// Set Workout time goal
  ///
  /// Data interpereted as Time*
  static CsafeLongCommandFactory cmdSetTWork =
      CsafeLongCommandFactory(0x20, CsafeTimePlaceholder());



  /// Vertical distance goal
  ///
  /// Data interpereted as Integer plus Unit* specifier
  static CsafeLongCommandFactory cmdSetVertical = CsafeLongCommandFactory(
      0x22, CsafeIntegerWithUnitsPlaceholder(3, UnitType.distance));

  /// Calories goal
  ///
  /// Data interpereted as Integer
  static CsafeLongCommandFactory cmdSetCalories =
      CsafeLongCommandFactory(0x23, CsafePlaceholder(2));

  

  /// Equipment speed
  ///
  /// Data interpereted as Integer plus Unit* specifier
  static CsafeLongCommandFactory cmdSetSpeed = CsafeLongCommandFactory(
      0x25, CsafeIntegerWithUnitsPlaceholder(3, UnitType.speed));

  /// Equipment grade (incline)
  ///
  /// Data interpereted as Integer plus Unit* specifier
  static CsafeLongCommandFactory cmdSetGrade = CsafeLongCommandFactory(
      0x28, CsafeIntegerWithUnitsPlaceholder(3, UnitType.dimensionless));

  /// Equipment gear (resistance)
  ///
  /// Data interpereted as Byte
  static CsafeLongCommandFactory cmdSetGear =
      CsafeLongCommandFactory(0x29, CsafePlaceholder(1));

  /// General user information
  ///
  /// Data interpereted as Integer (weight) +  Weight units* + Byte (age) + Byte (gender)
  static CsafeLongCommandFactory cmdSetUserInfo =
      CsafeLongCommandFactory(0x2B, CsafePlaceholder(5));
  //TODO: need classes to handle/validate these user info data fields

  /// Equipment torque
  ///
  /// Data interpereted as Integer plus Unit* specifier
  static CsafeLongCommandFactory cmdSetTorque = CsafeLongCommandFactory(
      0x2C, CsafeIntegerWithUnitsPlaceholder(3, UnitType.force));

  /// Level
  ///
  /// Data interpereted as Byte
  static CsafeLongCommandFactory cmdSetLevel =
      CsafeLongCommandFactory(0x2D, CsafePlaceholder(1));

  /// Target HR (bpm)
  ///
  /// Data interpereted as byte
  static CsafeLongCommandFactory cmdSetTargetHR =
      CsafeLongCommandFactory(0x30, CsafePlaceholder(1));

  /// Sets a workout goal
  ///
  /// Data interpereted as 0-255
  static CsafeLongCommandFactory cmdSetGoal =
      CsafeLongCommandFactory(0x32, CsafePlaceholder(1));

  /// METS goal
  ///
  /// Data Interpereted as Integer
  static CsafeLongCommandFactory cmdSetMETS =
      CsafeLongCommandFactory(0x33, CsafePlaceholder(2));


  /// Target HR zone (bpm)
  ///
  /// Data Interpereted as Byte (Min) + Byte (Max)
  static CsafeLongCommandFactory cmdSetHRZone =
      CsafeLongCommandFactory(0x35, CsafePlaceholder(2));

  /// Maximum HR limit (bpm)
  ///
  /// Data Interpereted as Byte
  static CsafeLongCommandFactory cmdSetHRMax =
      CsafeLongCommandFactory(0x36, CsafePlaceholder(1));

  /// Audio channel range (inclusive)
  ///
  /// Data Interpereted as Byte (Low) + Byte (High)
  static CsafeLongCommandFactory cmdSetChannelRange =
      CsafeLongCommandFactory(0x40, CsafePlaceholder(2));

  /// Audio volume range (inclusive)
  ///
  /// Data Interpereted as Byte (Low) + Byte (High)
  static CsafeLongCommandFactory cmdSetVolumeRange =
      CsafeLongCommandFactory(0x41, CsafePlaceholder(2));

  /// Set audio muting state
  ///
  /// Data Interpereted as Byte
  static CsafeLongCommandFactory cmdSetAudioMute =
      CsafeLongCommandFactory(0x42, CsafePlaceholder(1));

  /// Set audio channel
  ///
  /// Data Interpereted as Byte
  static CsafeLongCommandFactory cmdSetAudioChannel =
      CsafeLongCommandFactory(0x43, CsafePlaceholder(1));

  /// Set audio volume
  ///
  /// Data Interpereted as Byte
  static CsafeLongCommandFactory cmdSetAudioVolume =
      CsafeLongCommandFactory(0x44, CsafePlaceholder(1));

  /// Codes used to uniquely identify equipment and ROM version.
  ///
  /// Server data bytes: 5 + ?4
  /// Data Interpereted As: Manufacturer, CID, Model, Version, Release
  /// Valid range (inclusive): N/A
  /// Allowed server states: all
  static CsafeCommand cmdGetVersion = CsafeCommand.short(0x91);

  /// ID # defined for the user
  ///
  /// Server data bytes: 2-5
  /// Data Interpereted As: text
  /// Valid range (inclusive): 00000 – 99999
  /// Allowed server states: all
  static CsafeCommand cmdGetID = CsafeCommand.short(0x92);

  /// Unit Mode (Metric/English)
  ///
  /// Server data bytes:1
  /// Data Interpereted as: Logical
  /// Valid range (inclusive): 0-Metric, 1-English
  /// Allowed server states: 	all
  static CsafeCommand cmdGetUnits = CsafeCommand.short(0x93);

  /// Return equipment serial number
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom5
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  static CsafeCommand cmdGetSerial = CsafeCommand.short(0x94);

  /// List of batched commands configured with cmdUpList.3
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  static CsafeCommand cmdGetList = CsafeCommand.short(0x98);

  /// Hours used since manufactured
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: 3 byte integer
  /// Valid range (inclusive): 0 to 16777215
  /// Allowed server states: all
  static CsafeCommand cmdGetUtilization = CsafeCommand.short(0x99);

  /// Motor current
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: Integer plus Unit1 specifier
  /// Valid range (inclusive): 0-65,535
  /// Allowed server states: all
  static CsafeCommand cmdGetMotorCurrent = CsafeCommand.short(0x9A);

  /// Equipment odometer value
  ///
  /// Server data bytes: 5
  /// Data Interpereted As: 4 byte integer plus Unit1 specifier
  /// Valid range (inclusive): 0 to 4294967295
  /// Allowed server states: all
  static CsafeCommand cmdGetOdometer = CsafeCommand.short(0x9B);

  /// Equipment error code
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: 3 byte integer
  /// Valid range (inclusive): 0 to 16777215
  /// Allowed server states: all
  static CsafeCommand cmdGetErrorCode = CsafeCommand.short(0x9C);

  /// Equipment service code
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: 3 byte integer
  /// Valid range (inclusive): 0 to 16777215
  /// Allowed server states: all
  static CsafeCommand cmdGetServiceCode = CsafeCommand.short(0x9D);

  /// Server dependent configuration data
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  static CsafeCommand cmdGetUserCfg1 = CsafeCommand.short(0x9E);

  /// Server dependent configuration data
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  static CsafeCommand cmdGetUserCfg2 = CsafeCommand.short(0x9F);
}
*/