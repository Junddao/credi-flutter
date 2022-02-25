import 'dart:convert';

class FaqResponse {
  String? result;
  String? message;
  List<FaqResponseData>? data;
  FaqResponse({
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

  factory FaqResponse.fromMap(Map<String, dynamic> map) {
    return FaqResponse(
      result: map['result'],
      message: map['message'],
      data: List<FaqResponseData>.from(
          map['data']?.map((x) => FaqResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqResponse.fromJson(String source) =>
      FaqResponse.fromMap(json.decode(source));
}

class FaqResponseData {
  int? faqId;
  String? createdAt;
  String? updatedAt;
  FaqModel? faq;
  FaqResponseData({
    this.faqId,
    this.createdAt,
    this.updatedAt,
    this.faq,
  });

  Map<String, dynamic> toMap() {
    return {
      'faqId': faqId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'faq': faq?.toMap(),
    };
  }

  factory FaqResponseData.fromMap(Map<String, dynamic> map) {
    return FaqResponseData(
      faqId: map['faqId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      faq: FaqModel.fromMap(map['faq']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqResponseData.fromJson(String source) =>
      FaqResponseData.fromMap(json.decode(source));
}

class FaqModel {
  int? id;
  String? title;
  String? description;
  bool? isSelected;
  FaqModel({
    this.id,
    this.title,
    this.description,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqModel.fromJson(String source) =>
      FaqModel.fromMap(json.decode(source));
}
