// To parse this JSON data, do
//
//     final clientResource = clientResourceFromJson(jsonString);

import 'dart:convert';

ClientResource clientResourceFromJson(String str) => ClientResource.fromJson(json.decode(str));

String clientResourceToJson(ClientResource data) => json.encode(data.toJson());

class ClientResource {
  ClientResource({
    this.devices,
  });

  List<Device> devices;

  factory ClientResource.fromJson(Map<String, dynamic> json) => ClientResource(
    devices: List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
  };
}

class Device {
  Device({
    this.id,
    this.name,
    this.application,
    this.platform,
    this.createdAt,
    this.lastLogin,
    this.tokenTypes,
    this.mobileAuthenticationEnabled,
  });

  String id;
  String name;
  String application;
  String platform;
  String createdAt;
  String lastLogin;
  List<String> tokenTypes;
  bool mobileAuthenticationEnabled;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["id"],
    name: json["name"],
    application: json["application"],
    platform: json["platform"],
    createdAt: json["created_at"],
    lastLogin: json["last_login"],
    tokenTypes: json["token_types"],
    mobileAuthenticationEnabled: json["mobile_authentication_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "application": application,
    "platform": platform,
    "created_at": createdAt,
    "last_login": lastLogin,
    "token_types": List<dynamic>.from(tokenTypes.map((x) => x)),
    "mobile_authentication_enabled": mobileAuthenticationEnabled,
  };
}
