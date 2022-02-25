import 'dart:convert';

class CommonResponse {
  String? result;
  String? message;
  dynamic data;
  CommonResponse({
    this.result,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'message': message,
      'data': data,
    };
  }

  factory CommonResponse.fromMap(Map<String, dynamic> map) {
    return CommonResponse(
      result: map['result'],
      message: map['message'],
      data: map['data'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommonResponse.fromJson(String source) =>
      CommonResponse.fromMap(json.decode(source));
}
