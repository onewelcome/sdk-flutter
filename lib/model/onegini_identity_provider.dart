// To parse this JSON data, do
//
//     final provider = providerFromJson(jsonString);

import 'dart:convert';

List<OneginiIdentityProvider> providerFromJson(String str) => List<OneginiIdentityProvider>.from(json.decode(str).map((x) => OneginiIdentityProvider.fromJson(x)));

String providerToJson(List<OneginiIdentityProvider> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OneginiIdentityProvider {
  OneginiIdentityProvider({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory OneginiIdentityProvider.fromJson(Map<String, dynamic> json) => OneginiIdentityProvider(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
