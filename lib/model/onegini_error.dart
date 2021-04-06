// To parse this JSON data, do
//
//     final authenticationAttempt = authenticationAttemptFromJson(jsonString);

import 'dart:convert';

OneginiError oneginiErrorFromJson(String str) => OneginiError.fromJson(json.decode(str));

String oneginiErrorToJson(OneginiError data) => json.encode(data.toJson());

class OneginiError {
  OneginiError({
    this.message,
    this.code,
  });

  String? message;
  String? code;

  factory OneginiError.fromJson(Map<String, dynamic> json) => OneginiError(
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
  };
}
