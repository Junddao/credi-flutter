import 'dart:convert';

class Product {
  int? userId;
  String? name;
  String? description;
  String? material;
  String? phoneNumber;
  String? productName;
  List<String>? imageUrl;
  bool? isConsultingNeeded;
  String? budget;
  int? quantity;
  String? state;
  int? makerId;
  int? width;
  int? height;
  int? depth;
  bool? hasDrawing;
  bool? isExpired;
  Product({
    this.userId,
    this.name,
    this.description,
    this.material,
    this.phoneNumber,
    this.productName,
    this.imageUrl,
    this.isConsultingNeeded,
    this.budget,
    this.quantity,
    this.state,
    this.makerId,
    this.width,
    this.height,
    this.depth,
    this.hasDrawing,
    this.isExpired,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'material': material,
      'phoneNumber': phoneNumber,
      'productName': productName,
      'imageUrl': imageUrl,
      'isConsultingNeeded': isConsultingNeeded,
      'budget': budget,
      'quantity': quantity,
      'state': state,
      'makerId': makerId,
      'width': width,
      'height': height,
      'depth': depth,
      'hasDrawing': hasDrawing,
      'isExpired': isExpired,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      userId: map['userId'] != null ? map['userId'] : null,
      name: map['name'] != null ? map['name'] : null,
      description: map['description'] != null ? map['description'] : null,
      material: map['material'] != null ? map['material'] : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] : null,
      productName: map['productName'] != null ? map['productName'] : null,
      imageUrl:
          map['imageUrl'] != null ? List<String>.from(map['imageUrl']) : null,
      isConsultingNeeded:
          map['isConsultingNeeded'] != null ? map['isConsultingNeeded'] : null,
      budget: map['budget'] != null ? map['budget'] : null,
      quantity: map['quantity'] != null ? map['quantity'] : null,
      state: map['state'] != null ? map['state'] : null,
      makerId: map['makerId'] != null ? map['makerId'] : null,
      width: map['width'] != null ? map['width'] : null,
      height: map['height'] != null ? map['height'] : null,
      depth: map['depth'] != null ? map['depth'] : null,
      hasDrawing: map['hasDrawing'] != null ? map['hasDrawing'] : null,
      isExpired: map['isExpired'] != null ? map['isExpired'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
