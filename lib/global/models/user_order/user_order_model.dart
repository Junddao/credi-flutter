import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserOrder {
  int? productId;
  String? productJson;
  int? fromUserId;
  String? fromUserName;
  int? toUserId;
  String? toUserName;
  int? chatRoomId;
  String? chatRoomIds;
  bool? isAccepted;
  String? state;

  bool? isConsultingNeeded = false;
  int? price;
  int? quantity;
  final String? createdAt;
  final String? updatedAt;
  UserOrder({
    this.productId,
    this.productJson,
    this.fromUserId,
    this.fromUserName,
    this.toUserId,
    this.toUserName,
    this.chatRoomId = 0,
    this.chatRoomIds,
    this.isConsultingNeeded,
    this.price,
    this.quantity,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.isAccepted = false,
  });

  UserOrder copyWith({
    int? productId,
    String? productJson,
    int? fromUserId,
    String? fromUserName,
    int? toUserId,
    String? toUserName,
    int? chatRoomId,
    String? chatRoomIds,
    bool? isConsultingNeeded,
    int? price,
    int? quantity,
    String? createdAt,
    String? updatedAt,
    bool? isAccepted,
    String? state,
  }) {
    return UserOrder(
      productId: productId ?? this.productId,
      productJson: productJson ?? this.productJson,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      toUserId: toUserId ?? this.toUserId,
      toUserName: toUserName ?? this.toUserName,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      chatRoomIds: chatRoomIds ?? this.chatRoomIds,
      isConsultingNeeded: isConsultingNeeded ?? this.isConsultingNeeded,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAccepted: isAccepted ?? this.isAccepted,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productJson': productJson,
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'toUserId': toUserId,
      'toUserName': toUserName,
      'chatRoomId': chatRoomId,
      'chatRoomIds': chatRoomIds,
      'isConsultingNeeded': isConsultingNeeded,
      'price': price,
      'quantity': quantity,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isAccepted': isAccepted,
      'state': state,
    };
  }

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    return UserOrder(
      productId: map['productId'],
      productJson: map['productJson'],
      fromUserId: map['fromUserId'],
      fromUserName: map['fromUserName'],
      toUserId: map['toUserId'],
      toUserName: map['toUserName'],
      chatRoomId: map['chatRoomId'],
      chatRoomIds: map['chatRoomIds'],
      isConsultingNeeded: map['isConsultingNeeded'],
      price: map['price'],
      quantity: map['quantity'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      isAccepted: map['isAccepted'],
      state: map['state'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserOrder.fromJson(String source) =>
      UserOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(productId: $productId, productJson: $productJson, fromUserId: $fromUserId, fromUserName: $fromUserName, toUserId: $toUserId, toUserName: $toUserName, chatRoomId: $chatRoomId, isConsultingNeeded: $isConsultingNeeded, price: $price, quantity: $quantity, createdAt: $createdAt, updatedAt: $updatedAt, isAccepted: $isAccepted, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserOrder &&
        other.productId == productId &&
        other.productJson == productJson &&
        other.fromUserId == fromUserId &&
        other.fromUserName == fromUserName &&
        other.toUserId == toUserId &&
        other.toUserName == toUserName &&
        other.chatRoomId == chatRoomId &&
        other.chatRoomIds == chatRoomIds &&
        other.isConsultingNeeded == isConsultingNeeded &&
        other.price == price &&
        other.quantity == quantity &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isAccepted == isAccepted &&
        other.state == state;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        productJson.hashCode ^
        fromUserId.hashCode ^
        fromUserName.hashCode ^
        toUserId.hashCode ^
        toUserName.hashCode ^
        chatRoomId.hashCode ^
        chatRoomIds.hashCode ^
        isConsultingNeeded.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isAccepted.hashCode ^
        state.hashCode;
  }
}
