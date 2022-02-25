import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WebSocketChangeNotifier extends ChangeNotifier {
  String message = '';

  Future<void> setMessage(String recvMessage) async {
    message = recvMessage;
    if (message == "connected") {
      Logger().d("Connection establised.");
    }
    // 채팅방 id
    else {
      Logger().d('web-socket_message :$message');
    }
    notifyListeners();
  }
}
