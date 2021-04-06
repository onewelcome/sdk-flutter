// To parse this JSON data, do
//
//     final authenticationAttempt = authenticationAttemptFromJson(jsonString);

import 'dart:convert';

OneginiError oneginiErrorFromJson(String str) {
  var value;
  try {
   value = json.decode(str);
  } catch (error) {
    print("can't decode error");
  }
  if (value != null) {
    return OneginiError.fromJson(value);
  } else {
    var _error = OneginiError();
    _error.code = "401";
    _error.message = str;
    return _error;
  }
}

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
