import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'onegini.dart';

class ResourcesMethods {
  Future<String> getResourceWithAnonymousResourceOkHttpClient(
    String path,
    String scope, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.getResource, <String, dynamic>{
        'path': path,
        'method': method,
        'encoding': encoding,
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> getResourceWithResourceOkHttpClient(
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
        'method': method,
        'encoding': encoding,
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> getResourceWithImplicitResourceOkHttpClient(
    String path,
    String scope, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.getResource, <String, dynamic>{
        'path': path,
        'method': method,
        'encoding': encoding,
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
