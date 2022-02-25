import 'dart:convert';

class SystemAppVersionResponse {
  SystemAppVersionResponseData? data;
  SystemAppVersionResponse({
    this.data,
  });
  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }

  factory SystemAppVersionResponse.fromMap(Map<String, dynamic> map) {
    return SystemAppVersionResponse(
      data: SystemAppVersionResponseData.fromMap(
          map['data'] ?? SystemAppVersionResponseData().toMap()),
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory SystemAppVersionResponse.fromJson(String source) {
    return SystemAppVersionResponse.fromMap(json.decode(source));
  }
}

class SystemAppVersionResponseData {
  String? clientMinimumAppVersion;
  String? factoryMinimumAppVersion;
  String? clientCurrentAppVersion;
  String? factoryCurrentAppVersion;
  String? clientAppVersion;
  String? factoryAppVersion;
  SystemAppVersionResponseData({
    this.clientMinimumAppVersion,
    this.factoryMinimumAppVersion,
    this.clientCurrentAppVersion,
    this.factoryCurrentAppVersion,
    this.clientAppVersion,
    this.factoryAppVersion,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientMinimumAppVersion': clientMinimumAppVersion,
      'factoryMinimumAppVersion': factoryMinimumAppVersion,
      'clientCurrentAppVersion': clientCurrentAppVersion,
      'factoryCurrentAppVersion': factoryCurrentAppVersion,
      'clientAppVersion': clientAppVersion,
      'factoryAppVersion': factoryAppVersion,
    };
  }

  factory SystemAppVersionResponseData.fromMap(Map<String, dynamic> map) {
    return SystemAppVersionResponseData(
      clientMinimumAppVersion: map['clientMinimumAppVersion'],
      factoryMinimumAppVersion: map['factoryMinimumAppVersion'],
      clientCurrentAppVersion: map['clientCurrentAppVersion'],
      factoryCurrentAppVersion: map['factoryCurrentAppVersion'],
      clientAppVersion: map['clientAppVersion'],
      factoryAppVersion: map['factoryAppVersion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SystemAppVersionResponseData.fromJson(String source) =>
      SystemAppVersionResponseData.fromMap(json.decode(source));
}
