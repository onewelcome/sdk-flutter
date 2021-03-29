import 'dart:io';

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
      var response;
      if(Platform.isAndroid){
        response = await Onegini.instance.channel
            .invokeMethod(Constants.getResourceAnonymous, <String, dynamic>{
          'path': path,
          'scope': scope,
          'headers': headers,
          'method': method,
          'encoding': encoding,
          'body': body
        });
      }else{
        response = await Onegini.instance.channel
            .invokeMethod(Constants.getResource, <String, dynamic>{
          'path': path,
          'scope': scope,
          'headers': headers,
          'method': method,
          'encoding': encoding,
          'body': body
        });
      }

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

  Future<String> getResourceWithImplicitResourceOkHttpClient(
    String path,
    String scope, {
    Map<String, String>? headers,
    String? method,
    String? encoding,
    String? body,
  }) async {
    try {
      var response;
      if(Platform.isAndroid){
        response = await Onegini.instance.channel
            .invokeMethod(Constants.getImplicitResource, <String, dynamic>{
          'path': path,
          'scope': scope,
          'headers': headers,
          'method': method,
          'encoding': encoding,
          'body': body
        });
      }else {
        response = await Onegini.instance.channel
            .invokeMethod(Constants.getResource, <String, dynamic>{
          'path': path,
          'scope': scope,
          'headers': headers,
          'method': method,
          'encoding': encoding,
          'body': body
        });
      }

      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
