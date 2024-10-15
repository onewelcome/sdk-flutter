import 'package:onegini/onegini.gen.dart';

class RequestDetails {
  String path;
  HttpRequestMethod method;
  Map<String, String>? headers;
  String? body;

  RequestDetails(
      {required this.path, required this.method, this.headers, this.body});
}
