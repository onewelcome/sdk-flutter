// To parse this JSON data, do
//
//     final provider = providerFromJson(jsonString);

import 'dart:convert';

/// Parse json to list of Onegini response
List<OneginiListResponse> responseFromJson(String str) =>
    List<OneginiListResponse>.from(
        json.decode(str).map((x) => OneginiListResponse.fromJson(x)));

/// Parse Onegini response list to json
String responseToJson(List<OneginiListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OneginiListResponse {
  OneginiListResponse({
    this.id,
    this.name,
    this.type,
  });

  /// Response list ic
  String? id;

  /// Response list name
  String? name;

  /// Response type value
  ONGAuthenticatorType? type;

  factory OneginiListResponse.fromJson(Map<String, dynamic> json) =>
      OneginiListResponse(
        id: json["id"],
        name: json["name"],
        type: ONGAuthenticatorTypeExtension.type(
          json["type"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

enum ONGAuthenticatorType { pin, biometric, custom }

extension ONGAuthenticatorTypeExtension on ONGAuthenticatorType {
  static ONGAuthenticatorType? type(int? value) {
    if (value == null) {
      return null;
    }

    switch (value) {
      case 0:
        return ONGAuthenticatorType.pin;
      case 1:
        return ONGAuthenticatorType.biometric;
      default:
        return ONGAuthenticatorType.custom;
    }
  }
}
