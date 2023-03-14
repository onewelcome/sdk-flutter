// Wrapper class for pigeon class to enforce non null map values.
class RequestResponse {
  Map<String, String> headers;
  String body;
  bool ok;
  int status;

  RequestResponse({required this.headers, required this.body, required this.ok, required this.status});
}
