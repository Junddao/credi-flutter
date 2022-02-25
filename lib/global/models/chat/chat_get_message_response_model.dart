import 'dart:convert';

import 'package:crediApp/global/models/chat/chat_message_model.dart';
import 'package:crediApp/global/models/user_order/user_order_view_info_response_model.dart';

class ChatGetMessageResponse {
  String? result;
  String? message;
  List<ChatGetMessageResponseData>? data;
  ChatGetMessageResponse({
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

  factory ChatGetMessageResponse.fromMap(Map<String, dynamic> map) {
    return ChatGetMessageResponse(
      result: map['result'],
      message: map['message'],
      data: List<ChatGetMessageResponseData>.from(
          map['data']?.map((x) => ChatGetMessageResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatGetMessageResponse.fromJson(String source) =>
      ChatGetMessageResponse.fromMap(json.decode(source));
}

class ChatGetMessageResponseData {
  int? chatMessageId;
  ChatMessage? chatMessage;
  String? createdAt;
  UserOrderViewInfoResponseData? orderInfo;
  ChatGetMessageResponseData({
    this.chatMessageId,
    this.chatMessage,
    this.createdAt,
    this.orderInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatMessageId': chatMessageId,
      'chatMessage': chatMessage?.toMap(),
      'createdAt': createdAt,
      'orderInfo': orderInfo?.toMap(),
    };
  }

  factory ChatGetMessageResponseData.fromMap(Map<String, dynamic> map) {
    return ChatGetMessageResponseData(
      chatMessageId: map['chatMessageId'],
      chatMessage: ChatMessage.fromMap(map['chatMessage']),
      createdAt: map['createdAt'],
      orderInfo: UserOrderViewInfoResponseData.fromMap(
          map['orderInfo'] ?? UserOrderViewInfoResponseData().toMap()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatGetMessageResponseData.fromJson(String source) =>
      ChatGetMessageResponseData.fromMap(json.decode(source));
}
