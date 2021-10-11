// To parse this JSON data, do
//
//     final userProfileResponse = userProfileResponseFromJson(jsonString);

import 'dart:convert';
import 'custom_info.dart';

UserProfileResponse userProfileResponseFromJson(String str) => UserProfileResponse.fromJson(json.decode(str));

String userProfileResponseToJson(UserProfileResponse data) => json.encode(data.toJson());

class UserProfileResponse {
  UserProfileResponse({
    this.userProfile,
    this.customInfo,
  });

  UserProfile? userProfile;
  CustomInfo? customInfo;

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => UserProfileResponse(
    userProfile: UserProfile.fromJson(json["data"]),
    customInfo: CustomInfo.fromJson(json["customInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "userProfile": userProfile?.toJson(),
    "customInfo": customInfo?.toJson(),
  };
}

class UserProfile {
  UserProfile({
    this.isDefault,
    this.profileId,
  });

  String? profileId;
  bool? isDefault;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    profileId: json["profileId"],
    isDefault: json["isDefault"]
  );

  Map<String, dynamic> toJson() => {
    "profileId": profileId,
    "isDefault": isDefault
  };
}
