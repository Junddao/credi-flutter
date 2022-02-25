import 'dart:convert';

import 'package:crediApp/global/models/product/product_model.dart';

class ProductRequest {
  int? productId;
  Product? product;
  ProductRequest({
    this.productId,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'product': product?.toMap(),
    };
  }

  factory ProductRequest.fromMap(Map<String, dynamic> map) {
    return ProductRequest(
      productId: map['productId'],
      product: Product.fromMap(map['product']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductRequest.fromJson(String source) =>
      ProductRequest.fromMap(json.decode(source));
}
