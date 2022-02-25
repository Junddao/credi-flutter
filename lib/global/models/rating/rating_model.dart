import 'dart:convert';

class Rating {
  int? productId;
  String? productName;
  int? bidId;
  int? fromUserId;
  int? toUserId;
  String? review;
  double? score;
  List<String>? imageUrl;
  Rating({
    this.productId,
    this.productName,
    this.bidId,
    this.fromUserId,
    this.toUserId,
    this.review,
    this.score,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'bidId': bidId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'review': review,
      'score': score,
      'imageUrl': imageUrl,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      productId: map['productId'],
      productName: map['productName'],
      bidId: map['bidId'],
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      review: map['review'],
      score: map['score'],
      imageUrl: List<String>.from(map['imageUrl'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}
