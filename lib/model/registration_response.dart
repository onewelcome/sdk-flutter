// To parse this JSON data, do
//
//     final registrationResponse = registrationResponseFromJson(jsonString);

import 'dart:convert';

RegistrationResponse registrationResponseFromJson(String str) => RegistrationResponse.fromJson(json.decode(str));

String registrationResponseToJson(RegistrationResponse data) => json.encode(data.toJson());

class RegistrationResponse {
  RegistrationResponse({
    this.userProfile,
    this.customInfo,
  });

  UserProfile? userProfile;
  CustomInfo? customInfo;

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) => RegistrationResponse(
    userProfile: UserProfile.fromJson(json["userProfile"]),
    customInfo: CustomInfo.fromJson(json["customInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "userProfile": userProfile?.toJson(),
    "customInfo": customInfo?.toJson(),
  };
}

class CustomInfo {
  CustomInfo({
    this.status,
    this.data,
  });

  int? status;
  String? data;

  factory CustomInfo.fromJson(Map<String, dynamic>? json) => CustomInfo(
    status: json?["status"],
    data: json?["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
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
