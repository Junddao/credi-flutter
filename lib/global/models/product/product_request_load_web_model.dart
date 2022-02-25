import 'dart:convert';

class ProductReqeustLoadWebModel {
  String? phoneNumber;
  String? code;
  ProductReqeustLoadWebModel({
    this.phoneNumber,
    this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'code': code,
    };
  }

  factory ProductReqeustLoadWebModel.fromMap(Map<String, dynamic> map) {
    return ProductReqeustLoadWebModel(
      phoneNumber: map['phoneNumber'],
      code: map['code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductReqeustLoadWebModel.fromJson(String source) =>
      ProductReqeustLoadWebModel.fromMap(json.decode(source));
}
