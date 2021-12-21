import 'dart:typed_data';

import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:csafe_fitness/src/types/command_types.dart';
import 'package:csafe_fitness/src/types/datatypes.dart';

void main() {
  // Create a Csafe instance
  Csafe csafe = Csafe();

  // create a command

  CsafeCommand cmd1 =
      CsafeCommand.long(0xAB, 2, Uint8List.fromList([0xBE, 0xEF]));

  // alternatively, use a command factory
  // CsafeLongCommandFactory factory = CsafeLongCommandFactory(0xAB, placeholder);

  // CsafeCommand cmd2 = factory.buildFromValue(CsafeIntegerWithUnitsPlaceholder.meters(50));

  // send the command. You get a future for when the results come back!
  csafe.sendCommands([cmd1]).then((responseToCommands) => {
        //your handling of responses goes here
      });

  //this future can also throw errors if the command was badly formatted or illegal. these can be handled as errors

}
