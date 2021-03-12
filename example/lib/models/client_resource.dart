// To parse this JSON data, do
//
//     final clientResource = clientResourceFromJson(jsonString);

import 'dart:convert';

ClientResource clientResourceFromJson(String str) =>
    ClientResource.fromJson(json.decode(str));

String clientResourceToJson(ClientResource data) => json.encode(data.toJson());

class ClientResource {
  ClientResource({
    this.devices,
  });

  List<Device> devices;

  factory ClientResource.fromJson(Map<String, dynamic> json) => ClientResource(
        devices:
            List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
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
    this.model,
    this.platform,
    this.mobileAuthenticationEnabled,
    this.pushAuthenticationEnabled,
  });

  String id;
  String name;
  String application;
  String model;
  String platform;
  bool mobileAuthenticationEnabled;
  bool pushAuthenticationEnabled;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"] ?? "null",
        name: json["name"] ?? "null",
        application: json["application"] ?? "null",
        model: json["model"] ?? "null",
        platform: json["platform"] ?? "null",
        mobileAuthenticationEnabled:
            json["mobile_authentication_enabled"] ?? false,
        pushAuthenticationEnabled: json["push_authentication_enabled"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "application": application,
        "model": model,
        "platform": platform,
        "mobile_authentication_enabled": mobileAuthenticationEnabled,
        "push_authentication_enabled": pushAuthenticationEnabled,
      };
}
