# CSAFE Fitness Library

This is a dart library that implements the [CSAFE Protocol Framework](https://web.archive.org/web/20071207110624/http://www.fitlinxx.com/CSAFE/Framework.htm) used by fitness machines.

This CSAFE protocol is used in at least some devices made by:
- [Concept2](https://www.concept2.com/service/software/software-development-kit)
- [Wahoo Fitness](https://www.dcrainmaker.com/2016/01/announces-gymconnect-integration.html)
- [Cybex](https://www.cybexintl.com/manuals/treadmills/770t%20treadmill/english/lt-22983-4_htmlfiles/other/csafe_port.html)
- [Star Trac](https://support.corehandf.com/Brands/StarTrac/Manuals/620-8558B.pdf)
- [Primo Fitness](https://primofitnessusa.com/wp-content/uploads/2017/01/TRM-932i-MANUALS-111014-English-manual.pdf)
- [Matrix Fitness](https://www.matrixfitness.com/us/eng/cardio/consoles)

## Features
Currently this library has the ability to:
- Handle the most basic aspects of the CSAFE framing protocols
- Send CSAFE commands and receive the responses to them
- Represent CSAFE data types as Dart classes
- Provide objects to allow custom commands to be created beyond those present in the standard
- limit how many bytes are written to a device at a time to avoid exceeding limits


Some of its current limitations are:
- there has not yet been a lot of focus on handling unsolicited CSAFE frames sent by a device
- some commands, particularly for adjusting configuration parameters, are not yet added/supported
- there may potentially be timing issues with regard to matching commands with their responses if too many commands are sent too quickly or of a device responds to a command out of order


## Usage

To use this library, you will need to create a `read` function and a `write` function that can either accept some bytes and send them to the device you want to communicate with, or receive some bytes from that device using a Stream. 

To set up Csafe, just import the `Csafe` class and provide it with your read and write functions:

```dart
import 'package:csafe_fitness/csafe_fitness.dart';
// Create a Csafe instance
Csafe csafe = Csafe(myReadFunction, myWriteFunction);
```

A full example with fake read and write commands is provided in the [example](example/) folder.

### The Csafe class
The `Csafe` class is the core of the command processing as it contains the code to handle new data coming in from the read method's Stream as well as grouping and sending commands to the device. This class exposes a `sendCommands()` method where you can send either predefined commands, or ones you create yourself.

```dart

//Send a predefined command to tell the device to go to the inUse state.
csafe.sendCommands([cmdGoInUse]);

// Create a custom command with a payload containing 2 bytes
CsafeCommand customCommand =
      CsafeCommand.long(0xAB, 2, Uint8List.fromList([0xBE, 0xEF]).asCsafe());

// Send the custom command
csafe.sendCommands([customCommand]);
```

This `sendCommands` function returns a Future so you can access the results of each command in the order that you sent them.

```dart
List<CsafeCommandResponse> responses = await csafe.sendCommands([customCommand]);

//or you can use .then!

// send the command. You get a future for when the results come back!
csafe.sendCommands([customCommand]).then((responses) => {
	//your handling of responses goes here
	for (response in responses) {
		//...
	}
});
```

## Vocabulary

Where possible, this library tries to re-use language from the CSAFE specification.

One notable exception to this is that this library will use the term "server" instead of "slave" to represent the fitness device providing the data and the term "client" instead of "master" to represent the device that is requesting the data.  


## Unit Testing
Tests can be run with `dart test`.

Coverage reports can be created with the following commands:
```bash
dart test --coverage=./coverage
dart run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage # create the lcov.info file
genhtml -o ./coverage/report ./coverage/lcov.info # generate the report
```

These lines have also been added to a shell script located in `scripts/coveragereport.sh`.

## Assumptions made about the spec

This library assumes that, when a Csafe Frame is sent containing multiple commands, the responses to those commands will also be contained in a single frame.

This library also relies quite heavily on the order in which commands are responded to (and the order of responses within a frame) in order to match responses with the commands that they should go with. This is currently one area where improvement is needed in the future.