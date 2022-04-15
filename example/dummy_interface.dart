import 'dart:async';

import 'dart:typed_data';

class FakeInterface {
// https://dart.dev/articles/libraries/creating-streams#using-a-streamcontroller

  late StreamController<Uint8List> controller;

  FakeInterface() {
    controller = StreamController<Uint8List>();
  }

  void simulatePacket(Uint8List bytes) {
    controller.add(bytes);
  }

  Stream<Uint8List> get stream => controller.stream;
}
