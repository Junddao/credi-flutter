import 'dart:convert';

class Bid {
  int? productId;
  int? factoryId;
  String? name;
  String? companyName;
  String? material;
  String? location;
  int? quantityMin;
  int? cost;
  String? description;
  String? state;
  List<String>? imageUrl;
  String? mainProduct;
  Bid({
    this.productId,
    this.factoryId,
    this.name,
    this.companyName,
    this.material,
    this.location,
    this.quantityMin,
    this.cost,
    this.description,
    this.state,
    this.imageUrl,
    this.mainProduct,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'factoryId': factoryId,
      'name': name,
      'companyName': companyName,
      'material': material,
      'location': location,
      'quantityMin': quantityMin,
      'cost': cost,
      'description': description,
      'state': state,
      'imageUrl': imageUrl,
      'mainProduct': mainProduct,
    };
  }

  factory Bid.fromMap(Map<String, dynamic> map) {
    return Bid(
      productId: map['productId'],
      factoryId: map['factoryId'],
      name: map['name'],
      companyName: map['companyName'],
      material: map['material'],
      location: map['location'],
      quantityMin: map['quantityMin'],
      cost: map['cost'],
      description: map['description'],
      state: map['state'],
      imageUrl: List<String>.from(map['imageUrl']),
      mainProduct: map['mainProduct'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Bid.fromJson(String source) => Bid.fromMap(json.decode(source));

  Bid copyWith({
    int? productId,
    int? factoryId,
    String? name,
    String? companyName,
    String? material,
    String? location,
    int? quantityMin,
    int? cost,
    String? description,
    String? state,
    List<String>? imageUrl,
    String? mainProduct,
  }) {
    return Bid(
      productId: productId ?? this.productId,
      factoryId: factoryId ?? this.factoryId,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      material: material ?? this.material,
      location: location ?? this.location,
      quantityMin: quantityMin ?? this.quantityMin,
      cost: cost ?? this.cost,
      description: description ?? this.description,
      state: state ?? this.state,
      imageUrl: imageUrl ?? this.imageUrl,
      mainProduct: mainProduct ?? this.mainProduct,
    );
  }
}
