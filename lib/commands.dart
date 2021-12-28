import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';

class CsafePredefinedCommands {
  ///Request Status from Server.
  ///
  ///Status is sent even if the flgAck flag is off, i.e. this command can be added to a frame to force an acknowledgment of the frame even it the flgAck is off. Unlike the "Empty Frame" this command does update the Status.
  static CsafeCommand cmdGetStatus = CsafeCommand.short(0x80);

  ///Reset Server.
  ///
  ///Initialize variables to Ready State and reset Frame Toggle and Status of Previous Frame flag to zero.
  static CsafeCommand cmdReset = CsafeCommand.short(0x81);

  ///go to Idle State, reset variables to Idle state
  static CsafeCommand cmdGoIdle = CsafeCommand.short(0x82);

  ///go to HaveID state
  static CsafeCommand cmdGoHaveID = CsafeCommand.short(0x83);

  ///go to InUse State
  static CsafeCommand cmdGoInUse = CsafeCommand.short(0x85);

  ///go to Finished State
  static CsafeCommand cmdGoFinished = CsafeCommand.short(0x86);

  ///go to Ready State
  static CsafeCommand cmdGoReady = CsafeCommand.short(0x87);

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

  /// Set current time of day
  ///
  /// Data interpereted as Time*
  static CsafeLongCommandFactory cmdSetTIme =
      CsafeLongCommandFactory(0x11, CsafeTimePlaceholder());

  /// Set current date.
  ///
  /// Data interpereted as Date*
  static CsafeLongCommandFactory cmdSetDate =
      CsafeLongCommandFactory(0x12, CsafeDatePlaceholder());

  /// Set timeout period for exiting certain states. See state diagram for details.
  ///
  /// Data interpereted as Seconds
  static CsafeLongCommandFactory cmdSetTimeout =
      CsafeLongCommandFactory(0x13, CsafePlaceholder(1));

  /// Server depended configuration information
  ///
  /// Data interpereted as Custom
  // static CsafeLongCommandFactory cmdUserCfg1 =
  //     CsafeLongCommandFactory(0x1A, byteLength, data);

  /// Server depended configuration information
  ///
  /// Data interpereted as Custom
  // static CsafeLongCommandFactory cmdUserCfg2 =
  //     CsafeLongCommandFactory(0x1B, byteLength, data);

  /// Set Workout time goal
  ///
  /// Data interpereted as Time*
  static CsafeLongCommandFactory cmdSetTWork =
      CsafeLongCommandFactory(0x20, CsafeTimePlaceholder());

  ///Horizontal distance goal
  ///
  /// Data interpereted as Integer plus Unit* specifier

  // static CsafeLongCommandFactory cmdSetHorizontal =
  //     CsafeLongCommandFactory(0x21, CsafeIntegerWithUnitsPlaceholder(3));

  /// Vertical distance goal
  ///
  /// Data interpereted as Integer plus Unit* specifier
  // static CsafeLongCommandFactory cmdSetVertical =
  //     CsafeLongCommandFactory(0x22, CsafeIntegerWithUnitsPlaceholder(3));

  /// Calories goal
  ///
  /// Data interpereted as Integer
  // static CsafeLongCommandFactory cmdSetCalories = CsafeLongCommandFactory(0x23, 2, data);

  ///Machine program and level
  ///
  /// Data interpereted as Byte (program), Byte (level)
  static CsafeLongCommandFactory cmdSetProgram =
      CsafeLongCommandFactory(0x24, CsafePlaceholder(2));

  /// Equipment speed
  ///
  /// Data interpereted as Integer plus Unit* specifier
  // static CsafeLongCommandFactory cmdSetSpeed =
  //     CsafeLongCommandFactory(0x25, CsafeIntegerWithUnitsPlaceholder(3));

  /// Equipment grade (incline)
  ///
  /// Data interpereted as Integer plus Unit* specifier
  // static CsafeLongCommandFactory cmdSetGrade =
  //     CsafeLongCommandFactory(0x28, CsafeIntegerWithUnitsPlaceholder(3));

  /// Equipment gear (resistance)
  ///
  /// Data interpereted as Byte
  // static CsafeLongCommandFactory cmdSetGear = CsafeLongCommandFactory(0x29, 1, data);

  /// General user information
  ///
  /// Data interpereted as Integer (weight) +  Weight units* + Byte (age) + Byte (gender)
  // static CsafeLongCommandFactory cmdSetUserInfo = CsafeLongCommandFactory(0x2B, 5, data);

  /// Equipment torque
  ///
  /// Data interpereted as Integer plus Unit* specifier
  // static CsafeLongCommandFactory cmdSetTorque =
  // CsafeLongCommandFactory(0x2C, CsafeIntegerWithUnitsPlaceholder(3));

  /// Level
  ///
  /// Data interpereted as Byte
  // static CsafeLongCommandFactory cmdSetLevel = CsafeLongCommandFactory(0x2D, 1, data);

  /// Target HR (bpm)
  ///
  /// Data interpereted as byte
  // static CsafeLongCommandFactory cmdSetTargetHR = CsafeLongCommandFactory(0x30, 1, data);

  /// Sets a workout goal
  ///
  /// Data interpereted as 0-255
  static CsafeLongCommandFactory cmdSetGoal =
      CsafeLongCommandFactory(0x32, CsafePlaceholder(1));

  /// METS goal
  ///
  /// Data Interpereted as Integer
  // static CsafeLongCommandFactory cmdSetMETS = CsafeLongCommandFactory(0x33, 2, data);

  /// Power goal
  ///
  /// Data Interpereted as Integer plus Unit* specifier
  // static CsafeLongCommandFactory cmdSetPower =
  //     CsafeLongCommandFactory(0x34, CsafeIntegerWithUnitsPlaceholder(3));

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
  // static CsafeLongCommandFactory cmdGetVersion =
  //     CsafeLongCommandFactory(0x91, byteLength, data);

  /// ID # defined for the user
  ///
  /// Server data bytes: 2-5
  /// Data Interpereted As: text
  /// Valid range (inclusive): 00000 – 99999
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetID =
  //     CsafeLongCommandFactory(0x92, byteLength, data);

  /// Unit Mode (Metric/English)
  ///
  /// Server data bytes:1
  /// Data Interpereted as: Logical
  /// Valid range (inclusive): 0-Metric, 1-English
  /// Allowed server states: 	all
  // static CsafeLongCommandFactory cmdGetUnits =
  //     CsafeLongCommandFactory(0x93, byteLength, data);

  /// Return equipment serial number
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom5
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetSerial =
  //     CsafeLongCommandFactory(0x94, byteLength, data);

  /// List of batched commands configured with cmdUpList.3
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetList =
  //     CsafeLongCommandFactory(0x98, byteLength, data);

  /// Hours used since manufactured
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: 3 byte integer
  /// Valid range (inclusive): 0 to 16777215
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetUtilization =
  //     CsafeLongCommandFactory(0x99, byteLength, data);

  /// Motor current
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: Integer plus Unit1 specifier
  /// Valid range (inclusive): 0-65,535
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetMotorCurrent =
  //     CsafeLongCommandFactory(0x9A, byteLength, data);

  /// Equipment odometer value
  ///
  /// Server data bytes: 5
  /// Data Interpereted As: 4 byte integer plus Unit1 specifier
  /// Valid range (inclusive): 0 to 4294967295
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetOdometer =
  //     CsafeLongCommandFactory(0x9B, byteLength, data);

  /// Equipment error code
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: 3 byte integer
  /// Valid range (inclusive): 0 to 16777215
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetErrorCode =
  //     CsafeLongCommandFactory(0x9C, byteLength, data);

  /// Equipment service code
  ///
  /// Server data bytes: 3
  /// Data Interpereted As: 3 byte integer
  /// Valid range (inclusive): 0 to 16777215
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetServiceCode =
  //     CsafeLongCommandFactory(0x9D, byteLength, data);

  /// Server dependent configuration data
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetUserCfg1 =
  //     CsafeLongCommandFactory(0x9E, byteLength, data);

  /// Server dependent configuration data
  ///
  /// Server data bytes: ?
  /// Data Interpereted As: Custom
  /// Valid range (inclusive): Custom
  /// Allowed server states: all
  // static CsafeLongCommandFactory cmdGetUserCfg2 =
  //     CsafeLongCommandFactory(0x9F, byteLength, data);
}
