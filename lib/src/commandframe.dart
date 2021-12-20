import 'dart:typed_data';

import 'package:csafe_fitness/src/frame.dart';
import 'package:csafe_fitness/src/types/command_types.dart';

import 'helpers.dart';

/// An extension of Generic CsafeFrames that can handle existing CSAFE objects/structures
class CsafeCommandFrame extends CsafeFrame {
  CsafeCommandFrame.fromEncodedBytes(Uint8List encodedContents)
      : super.fromEncodedBytes(encodedContents);

  CsafeCommandFrame.fromCommands(List<CsafeCommand> commands)
      : super(commands
            .map((e) => e.toBytes())
            .reduce((a, b) => combineTwoLists(a, b)));

  CsafeCommandResponse asResponse() =>
      CsafeCommandResponse.fromBytes(frameContents);
}
