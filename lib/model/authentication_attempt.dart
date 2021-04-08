// To parse this JSON data, do
//
//     final authenticationAttempt = authenticationAttemptFromJson(jsonString);

import 'dart:convert';

/// Parse json to AuthenticationAttempt
AuthenticationAttempt authenticationAttemptFromJson(String str) =>
    AuthenticationAttempt.fromJson(json.decode(str));

/// Parse AuthenticationAttempt to json
String authenticationAttemptToJson(AuthenticationAttempt data) =>
    json.encode(data.toJson());

class AuthenticationAttempt {
  AuthenticationAttempt({
    this.failedAttempts,
    this.maxAttempts,
  });

  /// Number of failed attempts
  int? failedAttempts;

  /// Number of maximum attempts
  int? maxAttempts;

  factory AuthenticationAttempt.fromJson(Map<String, dynamic> json) =>
      AuthenticationAttempt(
        failedAttempts: json["failedAttempts"],
        maxAttempts: json["maxAttempts"],
      );

  Map<String, dynamic> toJson() => {
        "failedAttempts": failedAttempts,
        "maxAttempts": maxAttempts,
      };
}
