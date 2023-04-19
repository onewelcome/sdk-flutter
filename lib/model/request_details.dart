import 'package:onegini/pigeon.dart';

// Wrapper class for pigeon class to enforce non null map values.
class RequestDetails {
  String path;
  HttpRequestMethod method;
  Map<String, String>? headers;
  String? body;

  RequestDetails(
      {required this.path, required this.method, this.headers, this.body});
}
