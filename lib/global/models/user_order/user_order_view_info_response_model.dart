import 'dart:convert';

class UserOrderViewInfoResponse {
  String? result;
  String? message;
  UserOrderViewInfoResponseData? data;
  UserOrderViewInfoResponse({
    this.result,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'message': message,
      'data': data!.toMap(),
    };
  }

  factory UserOrderViewInfoResponse.fromMap(Map<String, dynamic> map) {
    return UserOrderViewInfoResponse(
      result: map['result'],
      message: map['message'],
      data: UserOrderViewInfoResponseData.fromMap(map['data']),
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory UserOrderViewInfoResponse.fromJson(String source) {
    return UserOrderViewInfoResponse.fromMap(json.decode(source));
  }
}

class UserOrderViewInfoResponseData {
  String? productName;
  String? orderCreateAt;
  String? orderUpdateAt;
  String? orderState;
  UserOrderViewInfoResponseData({
    this.productName,
    this.orderCreateAt,
    this.orderUpdateAt,
    this.orderState,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'orderCreateAt': orderCreateAt,
      'orderUpdateAt': orderUpdateAt,
      'orderState': orderState,
    };
  }

  factory UserOrderViewInfoResponseData.fromMap(Map<String, dynamic> map) {
    return UserOrderViewInfoResponseData(
      productName: map['productName'],
      orderCreateAt: map['orderCreateAt'],
      orderUpdateAt: map['orderUpdateAt'],
      orderState: map['orderState'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrderViewInfoResponseData.fromJson(String source) =>
      UserOrderViewInfoResponseData.fromMap(json.decode(source));
}
