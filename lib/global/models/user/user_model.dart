import 'dart:convert';

class User {
  String? email;
  String? userType;
  String? name;
  String? introduce;

  String? profileImage;
  List<String>? companyImages;
  bool? pushEnabled;
  bool? smsEnabled;
  bool? emailEnabled;
  bool? emailVerified;
  bool? agreeTerms;
  String? companyNumber;
  String? companyName;
  String? phoneNumber;
  String? address;
  String? mainProduct;
  String? fcmToken;
  User({
    this.email,
    this.userType = 'client',
    this.name = '',
    this.introduce,
    this.profileImage,
    this.companyImages,
    this.pushEnabled = true,
    this.smsEnabled = true,
    this.emailEnabled = true,
    this.emailVerified,
    this.agreeTerms,
    this.companyNumber,
    this.companyName,
    this.phoneNumber,
    this.address,
    this.mainProduct,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userType': userType,
      'name': name,
      'introduce': introduce,
      'profileImage': profileImage,
      'companyImages': companyImages,
      'pushEnabled': pushEnabled,
      'smsEnabled': smsEnabled,
      'emailEnabled': emailEnabled,
      'emailVerified': emailVerified,
      'agreeTerms': agreeTerms,
      'companyNumber': companyNumber,
      'companyName': companyName,
      'phoneNumber': phoneNumber,
      'address': address,
      'mainProduct': mainProduct,
      'fcmToken': fcmToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] != null ? map['email'] : null,
      userType: map['userType'] != null ? map['userType'] : null,
      name: map['name'] != null ? map['name'] : null,
      introduce: map['introduce'] != null ? map['introduce'] : null,
      profileImage: map['profileImage'] != null ? map['profileImage'] : null,
      companyImages: map['companyImages'] != null
          ? List<String>.from(map['companyImages'])
          : null,
      pushEnabled: map['pushEnabled'] != null ? map['pushEnabled'] : null,
      smsEnabled: map['smsEnabled'] != null ? map['smsEnabled'] : null,
      emailEnabled: map['emailEnabled'] != null ? map['emailEnabled'] : null,
      emailVerified: map['emailVerified'] != null ? map['emailVerified'] : null,
      agreeTerms: map['agreeTerms'] != null ? map['agreeTerms'] : null,
      companyNumber: map['companyNumber'] != null ? map['companyNumber'] : null,
      companyName: map['companyName'] != null ? map['companyName'] : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] : null,
      address: map['address'] != null ? map['address'] : null,
      mainProduct: map['mainProduct'] != null ? map['mainProduct'] : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? email,
    String? userType,
    String? name,
    String? introduce,
    String? profileImage,
    List<String>? companyImages,
    bool? pushEnabled,
    bool? smsEnabled,
    bool? emailEnabled,
    bool? emailVerified,
    bool? agreeTerms,
    String? companyNumber,
    String? companyName,
    String? phoneNumber,
    String? address,
    String? mainProduct,
    String? fcmToken,
  }) {
    return User(
      email: email ?? this.email,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      introduce: introduce ?? this.introduce,
      profileImage: profileImage ?? this.profileImage,
      companyImages: companyImages ?? this.companyImages,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      emailVerified: emailVerified ?? this.emailVerified,
      agreeTerms: agreeTerms ?? this.agreeTerms,
      companyNumber: companyNumber ?? this.companyNumber,
      companyName: companyName ?? this.companyName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      mainProduct: mainProduct ?? this.mainProduct,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
