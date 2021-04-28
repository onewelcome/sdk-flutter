

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  Event({
    required this.eventName,
    required this.eventValue,
  });

  String eventName;
  String eventValue;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    eventName: json["eventName"],
    eventValue: json["eventValue"],
  );

  Map<String, dynamic> toJson() => {
    "eventName": eventName,
    "eventValue": eventValue,
  };
}
