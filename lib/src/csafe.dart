import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:csafe_fitness/src/commandframe.dart';
import 'package:csafe_fitness/src/types/command_types.dart';

/// A simple interal object for associating a list of commands issued with its Completer
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

  /// Create a new Csafe object for parsing Csafe Data by passing in a read and write function
  ///
  /// The read function takes no parameters and returns a Stream<Uint8List>
  /// The write function takes in a Uint8List and returns void.
  Csafe(this.read, this.write) {
    // start listening to bytes from the read function
    _readSubscription = read().listen(_readLoop);
    _pendingCommandList = [];
  }

  /// An internal function that is run for every set of bytes read from the read function
  ///
  /// This function decodes csafe frames, validates them, matches them to commands that were previously sent, and fulfills their promises with the results (or an error)
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
    _PendingCommand matchingCommand = _pendingCommandList!.firstWhere(
        (element) => resp.matches(element.commandList),
        orElse: () => _pendingCommandList!.first);

    //TODO: what if it doesnt match anything? i.e. the byte received contains no responses or its an unsolicited byte?

    _pendingCommandList!.remove(matchingCommand);

    // validate that the command was successful based on the status byte
    if (_previousFrameCount == null) {
      _previousFrameCount = resp.status.frameCount;
      // resolve that future successfully
      matchingCommand.completer.complete(resp);
    } else if (_previousFrameCount == resp.status.frameCount) {
      //last packet received was not ok
      // resolve the future with an error
      // TODO: turn these status types into more proper error types that are easier for users to handle
      matchingCommand.completer
          .completeError("previous command state was ${resp.status.prevState}");
    } else {
      _previousFrameCount = resp.status.frameCount;
      // resolve that future successfully
      matchingCommand.completer.complete(resp);
    }
  }

  int _maxSingleCommand(List<CsafeCommand> items) =>
      items.map((e) => e.byteLength).reduce((a, b) => max(a, b));

  /// Sends a list of [CsafeCommand]s to a PM using the read and write handlers
  ///
  /// [sizeLimit] causes the commands to be split up into multiple transmissions so as not to exceed this number of bytes in any single transmission
  Future<List<CsafeCommandResponse>> sendCommands(List<CsafeCommand> commands,
      [int? sizeLimit]) {
    /// check for whether commands are flagrantly too big.
    /// this does not account for bytes added by framing, so there may still be issues if theres a hard upper limit.
    if (sizeLimit != null && _maxSingleCommand(commands) > sizeLimit) {
      throw ArgumentError(
          "At least one of the provided commands exceeds the specified maximum transmission size");
    }

    List<Future<CsafeCommandResponse>> futures = [];

    //TODO: attempt more efficient packing with more than one command per transmission if possible. see the commented code in this area for some ideas on how this might be done

    //create a frame from the first command
    ///the index of the next command to transmit
    int next = 0;

    /// the index of the last item in this transmission of commands
    // int transmissionEnd = 1;

    while (next < commands.length /*frame.byteLength < sizeLimit*/) {
      List<CsafeCommand> batch = [commands.elementAt(next)];
      // check that the command with the framing is not too big
      // CsafeCommandFrame frame =
      // CsafeCommandFrame.fromCommands(batch);
      futures.add(_makeTransmission(batch));
      next = next + 1;
    }

    //remove the responses from their arbitrary groups and make them a flat list that matches the input commands
    return Future.wait(futures)
        .then((items) => items.expand((i) => i.separate()).toList());
  }

  Future<CsafeCommandResponse> _makeTransmission(List<CsafeCommand> commands) {
    // create a future
    Completer<CsafeCommandResponse> completer = Completer();

    //store the future with the commands that it is asssociated with
    _pendingCommandList!.add(_PendingCommand(commands, completer));

    CsafeCommandFrame frame = CsafeCommandFrame.fromCommands(commands);

    // TODO: maybe set up some kind of retry timer/timeout here?

    write(frame.toBytes());

    return completer.future;
  }

  void destroy() {
    if (_readSubscription != null) {
      _readSubscription!.cancel();
    }
  }
}
