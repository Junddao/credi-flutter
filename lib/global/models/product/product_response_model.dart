import 'dart:convert';

import 'package:crediApp/global/models/product/product_model.dart';

class ProductResponse {
  String? result;
  String? message;
  List<ProductResponseData>? data;
  ProductResponse({
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

  factory ProductResponse.fromMap(Map<String, dynamic> map) {
    return ProductResponse(
      result: map['result'],
      message: map['message'],
      data: List<ProductResponseData>.from(
          map['data']?.map((x) => ProductResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductResponse.fromJson(String source) =>
      ProductResponse.fromMap(json.decode(source));
}

class ProductResponseData {
  int? productId;
  Product? product;
  String? createdAt;
  String? updatedAt;
  ProductResponseData({
    this.productId,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'product': product?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ProductResponseData.fromMap(Map<String, dynamic> map) {
    return ProductResponseData(
      productId: map['productId'],
      product: Product.fromMap(map['product']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductResponseData.fromJson(String source) =>
      ProductResponseData.fromMap(json.decode(source));
}
