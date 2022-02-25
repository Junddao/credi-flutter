import 'dart:convert';

class SystemConfig {
  String? result;
  String? message;
  SystemConfigData? data;
  SystemConfig({
    this.result,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'message': message,
      'data': data,
    };
  }

  factory SystemConfig.fromMap(Map<String, dynamic> map) {
    return SystemConfig(
      result: map['result'] != null ? map['result'] : null,
      message: map['message'] != null ? map['message'] : null,
      data: map['data'] != null ? SystemConfigData.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SystemConfig.fromJson(String source) =>
      SystemConfig.fromMap(json.decode(source));
}

class SystemConfigData {
  String? address;
  String? phoneNumber;
  SystemConfigData({
    this.address,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory SystemConfigData.fromMap(Map<String, dynamic> map) {
    return SystemConfigData(
      address: map['address'] != null ? map['address'] : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SystemConfigData.fromJson(String source) =>
      SystemConfigData.fromMap(json.decode(source));
}
