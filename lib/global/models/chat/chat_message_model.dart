import 'dart:convert';

class ChatMessage {
  int? chatRoomId;
  String? chatRoomIds;
  int? sendUserId;
  String? sendUserName;
  String? message;
  String? type;
  int? userOrderId;

  ChatMessage({
    this.chatRoomId,
    this.chatRoomIds,
    this.sendUserId,
    this.sendUserName,
    this.message,
    this.type,
    this.userOrderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'chatRoomIds': chatRoomIds,
      'sendUserId': sendUserId,
      'sendUserName': sendUserName,
      'message': message,
      'type': type,
      'userOrderId': userOrderId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      chatRoomId: map['chatRoomId'],
      chatRoomIds: map['chatRoomIds'],
      sendUserId: map['sendUserId'],
      sendUserName: map['sendUserName'],
      message: map['message'],
      type: map['type'],
      userOrderId: map['userOrderId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));
}
