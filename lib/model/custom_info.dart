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