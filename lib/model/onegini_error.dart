// To parse this JSON data, do
//
//     final authenticationAttempt = authenticationAttemptFromJson(jsonString);

import 'dart:convert';

/// Parse json to OneginiError
OneginiError oneginiErrorFromJson(dynamic data) {
  var value;

  if (data is Map<String, dynamic>) {
    return OneginiError.fromJson(data);
  }

  try {
    value = json.decode(data);
  } catch (error) {
    print("can't decode error");
  }
  if (value != null) {
    return OneginiError.fromJson(value);
  } else {
    var _error = OneginiError();
    _error.code = 8001;
    _error.message = data;
    return _error;
  }
}

/// Parse OneginiError to json
String oneginiErrorToJson(OneginiError data) => json.encode(data.toJson());

class OneginiError {
  OneginiError({
    this.message,
    this.code,
  });

  String? message;
  int? code;

  factory OneginiError.fromJson(Map<String, dynamic> json) => OneginiError(
        message: json["message"],
        code: json["code"] is int ? json["code"] : int.parse(json["code"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
      };
}
