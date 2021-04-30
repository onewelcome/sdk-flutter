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
  });

  /// Response list ic
  String? id;

  /// Response list name
  String? name;

  factory OneginiListResponse.fromJson(Map<String, dynamic> json) =>
      OneginiListResponse(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
