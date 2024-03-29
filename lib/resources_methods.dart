import 'model/request_details.dart';
import 'model/request_response.dart';

import 'package:onegini/onegini.gen.dart';

/// The class with resources methods
class ResourcesMethods {
  final api = ResourceMethodApi();

  /// Gets any type of resource
  Future<RequestResponse> requestResource(
      ResourceRequestType type, RequestDetails details) async {
    var owDetails = OWRequestDetails(
        path: details.path,
        method: details.method,
        headers: details.headers,
        body: details.body);
    var owResponse = await api.requestResource(type, owDetails);

    owResponse.headers
        .removeWhere((key, value) => key == null || value == null);
    var headers = Map<String, String>.from(owResponse.headers);

    return RequestResponse(
        headers: headers,
        body: owResponse.body,
        ok: owResponse.ok,
        status: owResponse.status);
  }

  /// Gets resources anonymously.
  Future<RequestResponse> requestResourceAnonymous(
      RequestDetails details) async {
    var owDetails = OWRequestDetails(
        path: details.path,
        method: details.method,
        headers: details.headers,
        body: details.body);
    var owResponse =
        await api.requestResource(ResourceRequestType.anonymous, owDetails);

    owResponse.headers
        .removeWhere((key, value) => key == null || value == null);
    var headers = Map<String, String>.from(owResponse.headers);

    return RequestResponse(
        headers: headers,
        body: owResponse.body,
        ok: owResponse.ok,
        status: owResponse.status);
  }

  /// Gets authenticated resources.
  Future<RequestResponse> requestResourceAuthenticated(
      RequestDetails details) async {
    var owDetails = OWRequestDetails(
        path: details.path,
        method: details.method,
        headers: details.headers,
        body: details.body);
    var owResponse =
        await api.requestResource(ResourceRequestType.authenticated, owDetails);

    owResponse.headers
        .removeWhere((key, value) => key == null || value == null);
    var headers = Map<String, String>.from(owResponse.headers);

    return RequestResponse(
        headers: headers,
        body: owResponse.body,
        ok: owResponse.ok,
        status: owResponse.status);
  }

  /// Gets implicit resource.
  Future<RequestResponse> requestResourceImplicit(
      RequestDetails details) async {
    var owDetails = OWRequestDetails(
        path: details.path,
        method: details.method,
        headers: details.headers,
        body: details.body);
    var owResponse =
        await api.requestResource(ResourceRequestType.implicit, owDetails);

    owResponse.headers
        .removeWhere((key, value) => key == null || value == null);
    var headers = Map<String, String>.from(owResponse.headers);

    return RequestResponse(
        headers: headers,
        body: owResponse.body,
        ok: owResponse.ok,
        status: owResponse.status);
  }

  /// Gets unauthenticated resource.
  Future<RequestResponse> requestResourceUnauthenticated(
      RequestDetails details) async {
    var owDetails = OWRequestDetails(
        path: details.path,
        method: details.method,
        headers: details.headers,
        body: details.body);
    var owResponse = await api.requestResource(
        ResourceRequestType.unauthenticated, owDetails);

    owResponse.headers
        .removeWhere((key, value) => key == null || value == null);
    var headers = Map<String, String>.from(owResponse.headers);

    return RequestResponse(
        headers: headers,
        body: owResponse.body,
        ok: owResponse.ok,
        status: owResponse.status);
  }
}
