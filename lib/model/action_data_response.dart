import 'dart:convert';
import 'custom_info.dart';

ActionDataResponse actionDataResponseFromJson(String str) => ActionDataResponse.fromJson(json.decode(str));

class ActionDataResponse {
  ActionDataResponse({
    this.data,
    this.customInfo,
  });

  Map<String, dynamic>? data;
  CustomInfo? customInfo;

  factory ActionDataResponse.fromJson(Map<String, dynamic> json) => ActionDataResponse(
    data: json["data"],
    customInfo: CustomInfo.fromJson(json["customInfo"]),
  );
}