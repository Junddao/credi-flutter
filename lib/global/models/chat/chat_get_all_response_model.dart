import 'dart:convert';

import 'package:crediApp/global/models/chat/chat_message_model.dart';

class ChatGetAllResponse {
  String? result;
  String? message;
  List<ChatGetAllResponseData>? data;
  ChatGetAllResponse({
    this.result,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatGetAllResponse.fromMap(Map<String, dynamic> map) {
    return ChatGetAllResponse(
      result: map['result'],
      message: map['message'],
      data: List<ChatGetAllResponseData>.from(
          map['data']?.map((x) => ChatGetAllResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatGetAllResponse.fromJson(String source) =>
      ChatGetAllResponse.fromMap(json.decode(source));
}

class ChatGetAllResponseData {
  int? chatRoomId;
  int? clientId;
  int? factoryId;
  String? clientName;
  String? factoryName;
  int? bidId;
  String? createdAt;
  ChatMessage? chatMessage;
  int? newMessageCount;
  ChatGetAllResponseData({
    this.chatRoomId,
    this.clientId,
    this.factoryId,
    this.clientName,
    this.factoryName,
    this.bidId,
    this.createdAt,
    this.chatMessage,
    this.newMessageCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'clientId': clientId,
      'factoryId': factoryId,
      'clientName': clientName,
      'factoryName': factoryName,
      'bidId': bidId,
      'createdAt': createdAt,
      'chatMessage': chatMessage?.toMap(),
      'newMessageCount': newMessageCount,
    };
  }

  factory ChatGetAllResponseData.fromMap(Map<String, dynamic> map) {
    return ChatGetAllResponseData(
      chatRoomId: map['chatRoomId'],
      clientId: map['clientId'],
      factoryId: map['factoryId'],
      clientName: map['clientName'],
      factoryName: map['factoryName'],
      bidId: map['bidId'],
      createdAt: map['createdAt'],
      chatMessage:
          ChatMessage.fromMap(map['chatMessage'] ?? ChatMessage().toMap()),
      newMessageCount: map['newMessageCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatGetAllResponseData.fromJson(String source) =>
      ChatGetAllResponseData.fromMap(json.decode(source));
}
