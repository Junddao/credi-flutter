import 'dart:convert';

class FactoryBoardResponse {
  String? result;
  String? message;
  List<FactoryBoardResponseData>? data;
  FactoryBoardResponse({
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

  factory FactoryBoardResponse.fromMap(Map<String, dynamic> map) {
    return FactoryBoardResponse(
      result: map['result'],
      message: map['message'],
      data: List<FactoryBoardResponseData>.from(
          map['data']?.map((x) => FactoryBoardResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FactoryBoardResponse.fromJson(String source) =>
      FactoryBoardResponse.fromMap(json.decode(source));
}

class FactoryBoardResponseData {
  int? factoryBoardId;
  String? createdAt;
  String? updatedAt;

  FactoryBoardModel? factoryBoard;
  FactoryBoardResponseData({
    this.factoryBoardId,
    this.createdAt,
    this.updatedAt,
    this.factoryBoard,
  });

  Map<String, dynamic> toMap() {
    return {
      'factoryBoardId': factoryBoardId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'factoryBoard': factoryBoard?.toMap(),
    };
  }

  factory FactoryBoardResponseData.fromMap(Map<String, dynamic> map) {
    return FactoryBoardResponseData(
      factoryBoardId: map['factoryBoardId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      factoryBoard: FactoryBoardModel.fromMap(map['factoryBoard']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FactoryBoardResponseData.fromJson(String source) =>
      FactoryBoardResponseData.fromMap(json.decode(source));
}

class FactoryBoardModel {
  int? id;
  // String? factoryId;
  String? category;
  String? image;
  String? companyName;
  String? name;
  String? hashTag;
  FactoryBoardModel({
    this.id,
    this.category,
    this.image,
    this.companyName,
    this.name,
    this.hashTag,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'image': image,
      'companyName': companyName,
      'name': name,
      'hashTag': hashTag,
    };
  }

  factory FactoryBoardModel.fromMap(Map<String, dynamic> map) {
    return FactoryBoardModel(
      id: map['id'],
      category: map['category'],
      image: map['image'],
      companyName: map['companyName'],
      name: map['name'],
      hashTag: map['hashTag'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FactoryBoardModel.fromJson(String source) =>
      FactoryBoardModel.fromMap(json.decode(source));
}
