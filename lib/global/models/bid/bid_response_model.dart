import 'dart:convert';

import 'package:crediApp/global/models/bid/bid_model.dart';

class BidResponse {
  String? result;
  String? message;
  List<BidResponseData>? data;
  BidResponse({
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

  factory BidResponse.fromMap(Map<String, dynamic> map) {
    return BidResponse(
      result: map['result'],
      message: map['message'],
      data: List<BidResponseData>.from(
          map['data']?.map((x) => BidResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BidResponse.fromJson(String source) =>
      BidResponse.fromMap(json.decode(source));
}

class BidResponseData {
  int? bidId;
  Bid? bid;
  String? createdAt;
  String? updatedAt;
  BidResponseData({
    this.bidId,
    this.bid,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bidId': bidId,
      'bid': bid?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory BidResponseData.fromMap(Map<String, dynamic> map) {
    return BidResponseData(
      bidId: map['bidId'],
      bid: Bid.fromMap(map['bid']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BidResponseData.fromJson(String source) =>
      BidResponseData.fromMap(json.decode(source));

  BidResponseData copyWith({
    int? bidId,
    Bid? bid,
    String? createdAt,
    String? updatedAt,
  }) {
    return BidResponseData(
      bidId: bidId ?? this.bidId,
      bid: bid ?? this.bid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
