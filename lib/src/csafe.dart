import 'dart:async';
import 'dart:typed_data';

import 'package:csafe_fitness/src/commandframe.dart';
import 'package:csafe_fitness/src/types/command_types.dart';

class _PendingCommand {
  List<CsafeCommand> commandList;
  Completer<CsafeCommandResponse> completer;

  _PendingCommand(this.commandList, this.completer);
}

class Csafe {
  Stream<Uint8List> Function() read;
  StreamSubscription<void>? _readSubscription;
  Function(Uint8List) write;
  List<_PendingCommand>? _pendingCommandList;
  int? _previousFrameCount;

  Csafe(this.read, this.write) {
    // start listening to bytes from the read function
    _readSubscription = read().listen(_readLoop);
    _pendingCommandList = [];
  }

  void _readLoop(Uint8List frameBytes) {
    // deframe the bytes
    CsafeCommandFrame frame = CsafeCommandFrame.fromEncodedBytes(frameBytes);
    // validate the checksum,
    if (!frame.validate()) {
      return; //ignore the packet and move on
    }

    // decode into a CsafeCommandResponse
    CsafeCommandResponse resp = frame.asResponse();

    // attempt to match this response with the command that sent it
    _PendingCommand matchingCommand = _pendingCommandList!
        .firstWhere((element) => resp.matches(element.commandList));

    //TODO: what if it doesnt match anything? i.e. the byte received contains no responses or its an unsolicited byte?

    _pendingCommandList!.remove(matchingCommand);

    // validate that the command was successful based on the status byte
    if (_previousFrameCount == null) {
      _previousFrameCount = resp.status.frameCount;
    } else if (_previousFrameCount == resp.status.frameCount) {
      //last packet received was not ok
      // resolve the future with an error
      // TODO: turn these status types into more proper error types that are easier for users to handle
      matchingCommand.completer.completeError(resp.status.prevState);
    } else {
      // resolve that future successfully
      matchingCommand.completer.complete(resp);
    }
  }

  Future<CsafeCommandResponse> sendCommands(List<CsafeCommand> commands) {
    // create a future
    Completer<CsafeCommandResponse> completer = Completer();

    //store the future with the commands that it is asssociated with
    _pendingCommandList!.add(_PendingCommand(commands, completer));

    CsafeCommandFrame frame = CsafeCommandFrame.fromCommands(commands);

    write(frame.toBytes());

    return completer.future;
  }

  void destroy() {
    if (_readSubscription != null) {
      _readSubscription!.cancel();
    }
  }
}
