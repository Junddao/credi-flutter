import 'dart:convert';

class WebSocketMessageType {
  static String order = 'order';
  static String room = 'room';
}

class WebSocketMessage {
  int? chatRoomId;
  String? type;
  int? orderId;
  String? data;
  WebSocketMessage({
    this.chatRoomId,
    this.type,
    this.orderId,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'type': type,
      'orderId': orderId,
      'data': data,
    };
  }

  factory WebSocketMessage.fromMap(Map<String, dynamic> map) {
    return WebSocketMessage(
      chatRoomId: map['chatRoomId'],
      type: map['type'],
      orderId: map['orderId'],
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WebSocketMessage.fromJson(String source) =>
      WebSocketMessage.fromMap(json.decode(source));
}
