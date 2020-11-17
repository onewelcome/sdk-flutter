
import 'dart:async';

import 'package:flutter/services.dart';

class Onegini {
  static const MethodChannel _channel =
      const MethodChannel('onegini');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static const String startAppMethod = 'startApp';
  static const String getResourceMethod = 'getResource';
  static const String registrationMethod = 'registration';
  static const String getInfoMethod = "getInfo";

  static Future<bool> startApplication() async {
    var appStarted = false;
    try {
      appStarted = await _channel.invokeMethod(startAppMethod);
    } on PlatformException catch (error) {
      throw error;
    }
    return appStarted;
  }

  static Future<void> fetchResource() async {
    try {
      var resource = await _channel
          .invokeMethod(getResourceMethod, {"username": "stanislaw@onegini.com"});
      print(resource);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  static Future<String> registration() async {
    try {
      var userId = await _channel
          .invokeMethod(registrationMethod);
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
