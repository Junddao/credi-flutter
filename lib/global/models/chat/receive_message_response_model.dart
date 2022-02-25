import 'dart:convert';

class ReceiveMessageResponse {
  String? result;
  String? message;
  List<ReceiveMessageResponseData>? data;
}

class ReceiveMessageResponseData {
  int? messageId;
  int? sendUserId;
  String? sendUserName;
  String? message;
  String? type;
  String? productJson;
  String? createdAt;
  ReceiveMessageResponseData({
    this.messageId,
    this.sendUserId,
    this.sendUserName,
    this.message,
    this.type,
    this.productJson,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'sendUserId': sendUserId,
      'sendUserName': sendUserName,
      'message': message,
      'type': type,
      'productJson': productJson,
      'createdAt': createdAt,
    };
  }

  factory ReceiveMessageResponseData.fromMap(Map<String, dynamic> map) {
    return ReceiveMessageResponseData(
      messageId: map['messageId'],
      sendUserId: map['sendUserId'],
      sendUserName: map['sendUserName'],
      message: map['message'],
      type: map['type'],
      productJson: map['productJson'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiveMessageResponseData.fromJson(String source) =>
      ReceiveMessageResponseData.fromMap(json.decode(source));
}
