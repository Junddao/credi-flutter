import 'dart:convert';

import 'package:crediApp/global/models/user/user_model.dart';

class UserRequest {
  User user;

  UserRequest({
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
    };
  }

  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      user: User.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRequest.fromJson(String source) =>
      UserRequest.fromMap(json.decode(source));

  UserRequest copyWith({
    User? user,
  }) {
    return UserRequest(
      user: user ?? this.user,
    );
  }
}
