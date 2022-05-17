import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';
import 'package:convert/convert.dart';

import 'dummy_interface.dart';

void main() {
  //Here are some mock read and write functions (named from the libararies perspective)
  //read should create a stream to simulate a real device

  FakeInterface dummy = FakeInterface();

  Stream<Uint8List> dummyRead() {
    return dummy.stream.asyncMap((event) {
      print("device sent bytes: " + hex.encode(event.toList()));
      return event;
    });
  }

  // to simulate a packet from the erg, use dummy.simulatePacket(bytes)

  //write can just log the bytes  for the user since this isnt a real device
  void dummyWrite(Uint8List value) {
    print("device received write: " + hex.encode(value.toList()));
  }

  // Create a Csafe instance and pass in the read and write functions
  Csafe csafe = Csafe(dummyRead, dummyWrite);

  // create a command

  CsafeCommand cmd1 =
      CsafeCommand.long(0xAB, 2, Uint8List.fromList([0xBE, 0xEF]).asCsafe());

  // alternatively, use a command factory
  // CsafeLongCommandFactory factory = CsafeLongCommandFactory(0xAB, placeholder);

  // CsafeCommand cmd2 = factory.buildFromValue(CsafeIntegerWithUnitsPlaceholder.meters(50));

//Send a predefined command to tell the device to go to the inUse state.
  csafe.sendCommands([cmdGoInUse]);

// Create a custom command with a payload containing 2 bytes
  CsafeCommand customCommand =
      CsafeCommand.long(0xAB, 2, Uint8List.fromList([0xBE, 0xEF]).asCsafe());

// Send the custom command
  // csafe.sendCommands([customCommand]);

  // send the command. You get a future for when the results come back!
  csafe.sendCommands([cmd1]).then((responseToCommands) => {
        //your handling of responses goes here
      });

  //this future can also throw errors if the command was badly formatted or illegal. these can be handled as errors
}
