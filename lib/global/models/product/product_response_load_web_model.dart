import 'dart:convert';

class ProductResponseLoadWebModel {
  String? result;
  String? message;
  List<String>? data;
  ProductResponseLoadWebModel({
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

  factory ProductResponseLoadWebModel.fromMap(Map<String, dynamic> map) {
    return ProductResponseLoadWebModel(
      result: map['result'],
      message: map['message'],
      data: List<String>.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductResponseLoadWebModel.fromJson(String source) =>
      ProductResponseLoadWebModel.fromMap(json.decode(source));
}
