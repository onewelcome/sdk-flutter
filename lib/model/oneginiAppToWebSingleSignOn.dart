// To parse this JSON data, do
//
//     final oneginiAppToWebSingleSignOn = oneginiAppToWebSingleSignOnFromJson(jsonString);

import 'dart:convert';

OneginiAppToWebSingleSignOn oneginiAppToWebSingleSignOnFromJson(String str) => OneginiAppToWebSingleSignOn.fromJson(json.decode(str));

String oneginiAppToWebSingleSignOnToJson(OneginiAppToWebSingleSignOn data) => json.encode(data.toJson());

class OneginiAppToWebSingleSignOn {
  OneginiAppToWebSingleSignOn({
    this.token,
    this.redirectUrl,
  });

  String? token;
  String? redirectUrl;

  factory OneginiAppToWebSingleSignOn.fromJson(Map<String, dynamic> json) => OneginiAppToWebSingleSignOn(
    token: json["token"],
    redirectUrl: json["redirectUrl"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "redirectUrl": redirectUrl,
  };
}
