import 'package:onegini/pigeon.dart';

abstract class GenericRequest implements RequestPost, RequestGet {
}

class RequestPost {
  String path;
  Map<String, String>? headers;
  HttpRequestMethod method = HttpRequestMethod.post;
  String body;

  RequestPost({required this.path, required this.body, this.headers});
}

class RequestGet {
  String path;
  Map<String, String>? headers;
  HttpRequestMethod method = HttpRequestMethod.get;
  String? body;

  RequestGet({required this.path, this.headers});
}

// Wrapper class for pigeon class to enforce non null map values.
class RequestDetails {
  String path;
  HttpRequestMethod method;
  Map<String, String>? headers;
  String? body;

  RequestDetails({required this.path, required this.method, this.headers, this.body});
}
