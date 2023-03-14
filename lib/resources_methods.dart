import 'dart:ui';

import 'model/request_details.dart';
import 'model/request_response.dart';

import 'package:flutter/services.dart';
import 'package:onegini/pigeon.dart';

import 'constants/constants.dart';
import 'onegini.dart';

/// The class with resources methods
class ResourcesMethods {
  final api = ResourceMethodApi();

  /// Gets any type of resource
  Future<RequestResponse> resourceRequest(ResourceRequestType type, RequestDetails details) async {
    var owDetails = OWRequestDetails(path: details.path, method: details.method, headers: details.headers, body: details.body);
    var owResponse = await api.requestResource(type, owDetails);

    owResponse.headers.removeWhere((key, value) => key == null || value == null);
    var headers = Map<String, String>.from(owResponse.headers);

    return RequestResponse(headers: headers, body: owResponse.body, ok: owResponse.ok, status: owResponse.status);
  }


  /// Gets resources anonymously.
  ///
  /// Method requires [path] parameter.
  Future<String?> getResourceAnonymous(
    String path, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    Map<String, String>? params,
    String? body,
  }) async {
    var response;
    response = await Onegini.instance.channel
        .invokeMethod(Constants.getResourceAnonymous, <String, dynamic>{
      'path': path,
      'headers': headers,
      'method': method,
      'encoding': encoding,
      'parameters': params,
      'body': body
    });

    return response;
  }

  /// Gets resources.
  ///
  /// Method requires [path] parameter.
  Future<String?> getResource(
    String path, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    Map<String, String>? params,
    String? body,
  }) async {
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.getResource, <String, dynamic>{
        'path': path,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'parameters': params,
        'body': body
      });
      return response;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Gets implicit resource.
  ///
  /// Method requires [path] parameter.
  Future<String?> getResourceImplicit(
    String path, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    Map<String, String>? params,
    String? body,
  }) async {
    try {
      var response;

      response = await Onegini.instance.channel
          .invokeMethod(Constants.getImplicitResource, <String, dynamic>{
        'path': path,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'parameters': params,
        'body': body
      });

      return response;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  Future<String?> getUnauthenticatedResource(
    String path, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    Map<String, String>? params,
    String? body,
  }) async {
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.getUnauthenticatedResource, <String, dynamic>{
        'path': path,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'parameters': params,
        'body': body
      });
      return response;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }
}
