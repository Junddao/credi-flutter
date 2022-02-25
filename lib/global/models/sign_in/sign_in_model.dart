import 'dart:convert';

class SignInData {
  String? token;
  String? email;
  String? name;
  int? userId;
  bool? agreeTerms;
  String? socialEmail; // social Email 안넘어오는 문제  대응용 , server에서 받아오는 값과는 상관없음
  SignInData({
    this.token,
    this.email,
    this.name,
    this.userId,
    this.agreeTerms,
    this.socialEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'email': email,
      'name': name,
      'userId': userId,
      'agreeTerms': agreeTerms,
      'socialEmail': socialEmail,
    };
  }

  factory SignInData.fromMap(Map<String, dynamic> map) {
    return SignInData(
      token: map['token'],
      email: map['email'],
      name: map['name'],
      userId: map['userId'],
      agreeTerms: map['agreeTerms'],
      socialEmail: map['socialEmail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignInData.fromJson(String source) =>
      SignInData.fromMap(json.decode(source));
}
