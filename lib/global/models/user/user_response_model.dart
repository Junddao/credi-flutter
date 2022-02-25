import 'dart:convert';

import 'package:crediApp/global/models/user/user_model.dart';

class UserResponse {
  String? result;
  String? message;
  UserResponseData? data;
  UserResponse({
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

  factory UserResponse.fromMap(Map<String, dynamic> map) {
    return UserResponse(
      result: map['result'],
      message: map['message'],
      data: UserResponseData.fromMap(map['data'] ?? UserResponseData().toMap()),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponse.fromJson(String source) =>
      UserResponse.fromMap(json.decode(source));
}

class UserResponseData {
  int? userId;
  User? user;
  String? createdAt;
  String? updatedAt;
  UserResponseData({
    this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'user': user?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserResponseData.fromMap(Map<String, dynamic> map) {
    return UserResponseData(
      userId: map['userId'],
      user: User.fromMap(map['user'] ?? User().toMap()),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponseData.fromJson(String source) =>
      UserResponseData.fromMap(json.decode(source));
}
