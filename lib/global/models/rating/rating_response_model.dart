import 'dart:convert';

import 'package:crediApp/global/models/rating/rating_model.dart';

class RatingResponse {
  String? result;
  String? message;
  List<RatingResponseData>? data = [];
  RatingResponse({
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

  factory RatingResponse.fromMap(Map<String, dynamic> map) {
    return RatingResponse(
      result: map['result'],
      message: map['message'],
      data: List<RatingResponseData>.from(
          map['data']?.map((x) => RatingResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingResponse.fromJson(String source) =>
      RatingResponse.fromMap(json.decode(source));
}

class RatingResponseData {
  int? ratingId;
  Rating? rating;
  String? name;
  String? createdAt;
  String? updatedAt;
  RatingResponseData({
    this.ratingId,
    this.rating,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ratingId': ratingId,
      'rating': rating?.toMap(),
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RatingResponseData.fromMap(Map<String, dynamic> map) {
    return RatingResponseData(
      ratingId: map['ratingId'],
      rating: Rating.fromMap(map['rating'] ?? Rating().toMap()),
      name: map['name'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingResponseData.fromJson(String source) =>
      RatingResponseData.fromMap(json.decode(source));
}
