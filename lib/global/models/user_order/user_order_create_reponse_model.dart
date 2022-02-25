import 'dart:convert';

class UserOrderCreateResponse {
  String? result;
  String? message;
  UserOrderCreateResponseData? data;
  UserOrderCreateResponse({
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

  factory UserOrderCreateResponse.fromMap(Map<String, dynamic> map) {
    return UserOrderCreateResponse(
      result: map['result'],
      message: map['message'],
      data: UserOrderCreateResponseData.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrderCreateResponse.fromJson(String source) =>
      UserOrderCreateResponse.fromMap(json.decode(source));
}

class UserOrderCreateResponseData {
  int? id;
  UserOrderCreateResponseData({
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory UserOrderCreateResponseData.fromMap(Map<String, dynamic> map) {
    return UserOrderCreateResponseData(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrderCreateResponseData.fromJson(String source) =>
      UserOrderCreateResponseData.fromMap(json.decode(source));
}
