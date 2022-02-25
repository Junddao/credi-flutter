import 'dart:convert';

class MagazineResponse {
  String? result;
  String? message;
  List<MagazineResponseData>? data;
  MagazineResponse({
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

  factory MagazineResponse.fromMap(Map<String, dynamic> map) {
    return MagazineResponse(
      result: map['result'],
      message: map['message'],
      data: List<MagazineResponseData>.from(
          map['data']?.map((x) => MagazineResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MagazineResponse.fromJson(String source) =>
      MagazineResponse.fromMap(json.decode(source));
}

class MagazineResponseData {
  int? magazineId;
  String? createdAt;
  String? updatedAt;
  MagazineModel? magazine;
  MagazineResponseData({
    this.magazineId,
    this.createdAt,
    this.updatedAt,
    this.magazine,
  });

  Map<String, dynamic> toMap() {
    return {
      'magazineId': magazineId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'magazine': magazine?.toMap(),
    };
  }

  factory MagazineResponseData.fromMap(Map<String, dynamic> map) {
    return MagazineResponseData(
      magazineId: map['magazineId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      magazine: MagazineModel.fromMap(map['magazine']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MagazineResponseData.fromJson(String source) =>
      MagazineResponseData.fromMap(json.decode(source));
}

class MagazineModel {
  int? id;
  String? url;
  String? image;
  bool? isShow;
  MagazineModel({
    this.id,
    this.url,
    this.image,
    this.isShow,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'image': image,
      'isShow': isShow,
    };
  }

  factory MagazineModel.fromMap(Map<String, dynamic> map) {
    return MagazineModel(
      id: map['id'],
      url: map['url'],
      image: map['image'],
      isShow: map['isShow'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MagazineModel.fromJson(String source) =>
      MagazineModel.fromMap(json.decode(source));
}
