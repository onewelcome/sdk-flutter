import 'dart:convert';

ApplicationDetails applicationDetailsFromJson(String str) => ApplicationDetails.fromJson(json.decode(str));

String applicationDetailsToJson(ApplicationDetails data) => json.encode(data.toJson());

class ApplicationDetails {
  ApplicationDetails({
    this.applicationIdentifier,
    this.applicationPlatform,
    this.applicationVersion,
  });

  String applicationIdentifier;
  String applicationPlatform;
  String applicationVersion;

  factory ApplicationDetails.fromJson(Map<String, dynamic> json) => ApplicationDetails(
    applicationIdentifier: json["application_identifier"],
    applicationPlatform: json["application_platform"],
    applicationVersion: json["application_version"],
  );

  Map<String, dynamic> toJson() => {
    "application_identifier": applicationIdentifier,
    "application_platform": applicationPlatform,
    "application_version": applicationVersion,
  };
}
