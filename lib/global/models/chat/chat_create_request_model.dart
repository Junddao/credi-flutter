import 'dart:convert';

class ChatCreateRequest {
  int? clientId;
  int? factoryId;
  int? bidId;

  ChatCreateRequest({
    this.clientId,
    this.factoryId,
    this.bidId = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'factoryId': factoryId,
      'bidId': bidId,
    };
  }

  factory ChatCreateRequest.fromMap(Map<String, dynamic> map) {
    return ChatCreateRequest(
      clientId: map['clientId'],
      factoryId: map['factoryId'],
      bidId: map['bidId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatCreateRequest.fromJson(String source) =>
      ChatCreateRequest.fromMap(json.decode(source));
}
