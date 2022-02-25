import 'dart:convert';

import 'package:crediApp/global/models/user_order/user_order_model.dart';

class UserOrderResponse {
  String? result;
  String? message;
  List<UserOrderResponseData>? data;
  UserOrderResponse({
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

  factory UserOrderResponse.fromMap(Map<String, dynamic> map) {
    return UserOrderResponse(
      result: map['result'],
      message: map['message'],
      data: List<UserOrderResponseData>.from(
          map['data']?.map((x) => UserOrderResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrderResponse.fromJson(String source) =>
      UserOrderResponse.fromMap(json.decode(source));
}

class UserOrderResponseData {
  int? userOrderId;
  UserOrder? userOrder;
  String? createdAt;
  String? updatedAt;
  UserOrderResponseData({
    this.userOrderId,
    this.userOrder,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userOrderId': userOrderId,
      'userOrder': userOrder?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserOrderResponseData.fromMap(Map<String, dynamic> map) {
    return UserOrderResponseData(
      userOrderId: map['userOrderId'],
      userOrder: UserOrder.fromMap(map['userOrder']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrderResponseData.fromJson(String source) =>
      UserOrderResponseData.fromMap(json.decode(source));
}
