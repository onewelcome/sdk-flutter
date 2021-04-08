// To parse this JSON data, do
//
//     final provider = providerFromJson(jsonString);

import 'dart:convert';

/// Parse json to RemovedUserProfile
List<RemovedUserProfile> removedUserProfileListFromJson(String str) =>
    List<RemovedUserProfile>.from(
        json.decode(str).map((x) => RemovedUserProfile.fromJson(x)));

/// Parse RemovedUserProfile to json
String removedUserProfileListToJson(List<RemovedUserProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RemovedUserProfile {
  RemovedUserProfile({
    this.isDefault,
    this.profileId,
  });

  bool? isDefault;
  String? profileId;

  factory RemovedUserProfile.fromJson(Map<String, dynamic> json) =>
      RemovedUserProfile(
        isDefault: json["isDefault"],
        profileId: json["profileId"],
      );

  Map<String, dynamic> toJson() => {
        "isDefault": isDefault,
        "profileId": profileId,
      };
}
