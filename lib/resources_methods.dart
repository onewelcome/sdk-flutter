import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'onegini.dart';

/// The class with resources methods
class ResourcesMethods {
  /// Gets resources anonymously.
  ///
  /// Method requires [path] parameter.
  Future<String> getResourceAnonymous(
    String path,
    List<String> scopes, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response;
      response = await Onegini.instance.channel
          .invokeMethod(Constants.getResourceAnonymous, <String, dynamic>{
        'path': path,
        'scope': scopes,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'body': body
      });

      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Gets resources.
  ///
  /// Method requires [path] parameter.
  Future<String> getResource(
    String path, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.getResource, <String, dynamic>{
        'path': path,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'body': body
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Gets implicit resource.
  ///
  /// Method requires [path] parameter.
  Future<String> getResourceImplicit(
    String path,
    List<String> scope, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response;

      response = await Onegini.instance.channel
          .invokeMethod(Constants.getImplicitResource, <String, dynamic>{
        'path': path,
        'scope': scope,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'body': body
      });

      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> getUnauthenticatedResource(
    String path, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.getUnauthenticatedResource, <String, dynamic>{
        'path': path,
        'headers': headers,
        'method': method,
        'encoding': encoding,
        'body': body
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
