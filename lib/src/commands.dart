import 'package:csafe_fitness/src/types/command_types.dart';

///Request Status from Server.
///
///Status is sent even if the flgAck flag is off, i.e. this command can be added to a frame to force an acknowledgment of the frame even it the flgAck is off. Unlike the "Empty Frame" this command does update the Status.
CsafeShortCommand cmdGetStatus = CsafeShortCommand.fromByte(0x80);

///Reset Server.
///
///Initialize variables to Ready State and reset Frame Toggle and Status of Previous Frame flag to zero.
CsafeShortCommand cmdReset = CsafeShortCommand.fromByte(0x81);

///go to Idle State, reset variables to Idle state
CsafeShortCommand cmdGoIdle = CsafeShortCommand.fromByte(0x82);

///go to HaveID state
CsafeShortCommand cmdGoHaveID = CsafeShortCommand.fromByte(0x83);

///go to InUse State
CsafeShortCommand cmdGoInUse = CsafeShortCommand.fromByte(0x85);

///go to Finished State
CsafeShortCommand cmdGoFinished = CsafeShortCommand.fromByte(0x86);

///go to Ready State
CsafeShortCommand cmdGoReady = CsafeShortCommand.fromByte(0x87);

///Indicates to Server that the user ID entered was invalid
CsafeShortCommand cmdBadID = CsafeShortCommand.fromByte(0x88);

// ///Control automatic upload features. See table below for definition.
// CsafeShortCommand cmdAutoUpload = CsafeLongCommand.fromByte(0x01);

// ///List of commands that specify data for batched upload. *
// CsafeShortCommand cmdUpList = CsafeLongCommand.fromByte(0x02);

// ///Interval between periodic automatic uploads of status **
// CsafeShortCommand cmdUpStatusSec = CsafeLongCommand.fromByte(0x04);

// ///Interval between periodic automatic uploads of UpList
// CsafeShortCommand cmdUpListSec = CsafeLongCommand.fromByte(0x05);

/// An integer between 2 - 5 defining the number of digits to accept from the user as a valid ID
///
/// data interpereted as byte
CsafeLongCommand cmdIDDigits =
    CsafeLongCommand(CsafeCommandIdentifier(0x10), 1, data);

/// Set current time of day
///
/// Data interpereted as Time*
CsafeLongCommand cmdSetTIme =
    CsafeLongCommand(CsafeCommandIdentifier(0x11), 3, data);

/// Set current date.
///
/// Data interpereted as Date*
CsafeLongCommand cmdSetDate =
    CsafeLongCommand(CsafeCommandIdentifier(0x12), 3, data);

/// Set timeout period for exiting certain states. See state diagram for details.
///
/// Data interpereted as Seconds
CsafeLongCommand cmdSetTimeout =
    CsafeLongCommand(CsafeCommandIdentifier(0x13), 1, data);

/// Server depended configuration information
///
/// Data interpereted as Custom
CsafeLongCommand cmdUserCfg1 =
    CsafeLongCommand(CsafeCommandIdentifier(0x1A), byteLength, data);

/// Server depended configuration information
///
/// Data interpereted as Custom
CsafeLongCommand cmdUserCfg2 =
    CsafeLongCommand(CsafeCommandIdentifier(0x1B), byteLength, data);

/// Set Workout time goal
///
/// Data interpereted as Time*
CsafeLongCommand cmdSetTWork =
    CsafeLongCommand(CsafeCommandIdentifier(0x20), 3, data);

///Horizontal distance goal
///
/// Data interpereted as Integer plus Unit* specifier

CsafeLongCommand cmdSetHorizontal =
    CsafeLongCommand(CsafeCommandIdentifier(0x21), 3, data);

/// Vertical distance goal
///
/// Data interpereted as Integer plus Unit* specifier
CsafeLongCommand cmdSetVertical =
    CsafeLongCommand(CsafeCommandIdentifier(0x22), 3, data);

/// Calories goal
///
/// Data interpereted as Integer
CsafeLongCommand cmdSetCalories =
    CsafeLongCommand(CsafeCommandIdentifier(0x23), 2, data);

///Machine program and level
///
/// Data interpereted as Byte (program), Byte (level)
CsafeLongCommand cmdSetProgram =
    CsafeLongCommand(CsafeCommandIdentifier(0x24), 2, data);

/// Equipment speed
///
/// Data interpereted as Integer plus Unit* specifier
CsafeLongCommand cmdSetSpeed =
    CsafeLongCommand(CsafeCommandIdentifier(0x25), 3, data);

/// Equipment grade (incline)
///
/// Data interpereted as Integer plus Unit* specifier
CsafeLongCommand cmdSetGrade =
    CsafeLongCommand(CsafeCommandIdentifier(0x28), 3, data);

/// Equipment gear (resistance)
///
/// Data interpereted as Byte
CsafeLongCommand cmdSetGear =
    CsafeLongCommand(CsafeCommandIdentifier(0x29), 1, data);

/// General user information
///
/// Data interpereted as Integer (weight) +  Weight units* + Byte (age) + Byte (gender)
CsafeLongCommand cmdSetUserInfo =
    CsafeLongCommand(CsafeCommandIdentifier(0x2B), 5, data);

/// Equipment torque
///
/// Data interpereted as Integer plus Unit* specifier
CsafeLongCommand cmdSetTorque =
    CsafeLongCommand(CsafeCommandIdentifier(0x2C), 3, data);

/// Level
///
/// Data interpereted as Byte
CsafeLongCommand cmdSetLevel =
    CsafeLongCommand(CsafeCommandIdentifier(0x2D), 1, data);

/// Target HR (bpm)
///
/// Data interpereted as byte
CsafeLongCommand cmdSetTargetHR =
    CsafeLongCommand(CsafeCommandIdentifier(0x30), 1, data);

/// Sets a workout goal
///
/// Data interpereted as 0-255
CsafeLongCommand cmdSetGoal =
    CsafeLongCommand(CsafeCommandIdentifier(0x32), byteLength, data);

/// METS goal
///
/// Data Interpereted as Integer
CsafeLongCommand cmdSetMETS =
    CsafeLongCommand(CsafeCommandIdentifier(0x33), 2, data);

/// Power goal
///
/// Data Interpereted as Integer plus Unit* specifier
CsafeLongCommand cmdSetPower =
    CsafeLongCommand(CsafeCommandIdentifier(0x34), 3, data);

/// Target HR zone (bpm)
///
/// Data Interpereted as Byte (Min) + Byte (Max)
CsafeLongCommand cmdSetHRZone =
    CsafeLongCommand(CsafeCommandIdentifier(0x35), 2, data);

/// Maximum HR limit (bpm)
///
/// Data Interpereted as Byte
CsafeLongCommand cmdSetHRMax =
    CsafeLongCommand(CsafeCommandIdentifier(0x36), 1, data);

/// Audio channel range (inclusive)
///
/// Data Interpereted as Byte (Low) + Byte (High)
CsafeLongCommand cmdSetChannelRange =
    CsafeLongCommand(CsafeCommandIdentifier(0x40), 2, data);

/// Audio volume range (inclusive)
///
/// Data Interpereted as Byte (Low) + Byte (High)
CsafeLongCommand cmdSetVolumeRange =
    CsafeLongCommand(CsafeCommandIdentifier(0x41), 2, data);

/// Set audio muting state
///
/// Data Interpereted as Byte
CsafeLongCommand cmdSetAudioMute =
    CsafeLongCommand(CsafeCommandIdentifier(0x42), 1, data);

/// Set audio channel
///
/// Data Interpereted as Byte
CsafeLongCommand cmdSetAudioChannel =
    CsafeLongCommand(CsafeCommandIdentifier(0x43), 1, data);

/// Set audio volume
///
/// Data Interpereted as Byte
CsafeLongCommand cmdSetAudioVolume =
    CsafeLongCommand(CsafeCommandIdentifier(0x44), 1, data);

/// Codes used to uniquely identify equipment and ROM version.
///
/// Server data bytes: 5 + ?4
/// Data Interpereted As: Manufacturer, CID, Model, Version, Release
/// Valid range (inclusive): N/A
/// Allowed server states: all
CsafeLongCommand cmdGetVersion =
    CsafeLongCommand(CsafeCommandIdentifier(0x91), byteLength, data);

/// ID # defined for the user
///
/// Server data bytes: 2-5
/// Data Interpereted As: text
/// Valid range (inclusive): 00000 – 99999
/// Allowed server states: all
CsafeLongCommand cmdGetID =
    CsafeLongCommand(CsafeCommandIdentifier(0x92), byteLength, data);

/// Unit Mode (Metric/English)
///
/// Server data bytes:1
/// Data Interpereted as: Logical
/// Valid range (inclusive): 0-Metric, 1-English
/// Allowed server states: 	all
CsafeLongCommand cmdGetUnits =
    CsafeLongCommand(CsafeCommandIdentifier(0x93), byteLength, data);

/// Return equipment serial number
///
/// Server data bytes: ?
/// Data Interpereted As: Custom5
/// Valid range (inclusive): Custom
/// Allowed server states: all
CsafeLongCommand cmdGetSerial =
    CsafeLongCommand(CsafeCommandIdentifier(0x94), byteLength, data);

/// List of batched commands configured with cmdUpList.3
///
/// Server data bytes: ?
/// Data Interpereted As: Custom
/// Valid range (inclusive): Custom
/// Allowed server states: all
CsafeLongCommand cmdGetList =
    CsafeLongCommand(CsafeCommandIdentifier(0x98), byteLength, data);

/// Hours used since manufactured
///
/// Server data bytes: 3
/// Data Interpereted As: 3 byte integer
/// Valid range (inclusive): 0 to 16777215
/// Allowed server states: all
CsafeLongCommand cmdGetUtilization =
    CsafeLongCommand(CsafeCommandIdentifier(0x99), byteLength, data);

/// Motor current
///
/// Server data bytes: 3
/// Data Interpereted As: Integer plus Unit1 specifier
/// Valid range (inclusive): 0-65,535
/// Allowed server states: all
CsafeLongCommand cmdGetMotorCurrent =
    CsafeLongCommand(CsafeCommandIdentifier(0x9A), byteLength, data);

/// Equipment odometer value
///
/// Server data bytes: 5
/// Data Interpereted As: 4 byte integer plus Unit1 specifier
/// Valid range (inclusive): 0 to 4294967295
/// Allowed server states: all
CsafeLongCommand cmdGetOdometer =
    CsafeLongCommand(CsafeCommandIdentifier(0x9B), byteLength, data);

/// Equipment error code
///
/// Server data bytes: 3
/// Data Interpereted As: 3 byte integer
/// Valid range (inclusive): 0 to 16777215
/// Allowed server states: all
CsafeLongCommand cmdGetErrorCode =
    CsafeLongCommand(CsafeCommandIdentifier(0x9C), byteLength, data);

/// Equipment service code
///
/// Server data bytes: 3
/// Data Interpereted As: 3 byte integer
/// Valid range (inclusive): 0 to 16777215
/// Allowed server states: all
CsafeLongCommand cmdGetServiceCode =
    CsafeLongCommand(CsafeCommandIdentifier(0x9D), byteLength, data);

/// Server dependent configuration data
///
/// Server data bytes: ?
/// Data Interpereted As: Custom
/// Valid range (inclusive): Custom
/// Allowed server states: all
CsafeLongCommand cmdGetUserCfg1 =
    CsafeLongCommand(CsafeCommandIdentifier(0x9E), byteLength, data);

/// Server dependent configuration data
///
/// Server data bytes: ?
/// Data Interpereted As: Custom
/// Valid range (inclusive): Custom
/// Allowed server states: all
CsafeLongCommand cmdGetUserCfg2 =
    CsafeLongCommand(CsafeCommandIdentifier(0x9F), byteLength, data);
