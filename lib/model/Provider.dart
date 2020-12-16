// To parse this JSON data, do
//
//     final provider = providerFromJson(jsonString);

import 'dart:convert';

List<Provider> providerFromJson(String str) => List<Provider>.from(json.decode(str).map((x) => Provider.fromJson(x)));

String providerToJson(List<Provider> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Provider {
  Provider({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
