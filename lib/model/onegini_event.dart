import 'dart:convert';

OneginiEvent eventFromJson(String str) => OneginiEvent.fromJson(json.decode(str));

String eventToJson(OneginiEvent data) => json.encode(data.toJson());

class OneginiEvent {
  OneginiEvent({
    this.key,
    this.value,
  });

  String key;
  dynamic value;

  factory OneginiEvent.fromJson(Map<String, dynamic> json) => OneginiEvent(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}