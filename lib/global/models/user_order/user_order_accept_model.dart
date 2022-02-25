import 'dart:convert';

class UserOrderAccept {
  int? userOrderId;
  bool isAccept;
  UserOrderAccept({
    this.userOrderId,
    this.isAccept = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userOrderId': userOrderId,
      'isAccept': isAccept,
    };
  }

  factory UserOrderAccept.fromMap(Map<String, dynamic> map) {
    return UserOrderAccept(
      userOrderId: map['userOrderId'],
      isAccept: map['isAccept'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrderAccept.fromJson(String source) =>
      UserOrderAccept.fromMap(json.decode(source));
}
