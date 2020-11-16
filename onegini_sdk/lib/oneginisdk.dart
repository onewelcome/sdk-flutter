library oneginisdk;

/// A Calculator.
import 'package:flutter/services.dart';



/// Onegini class for communication between Flutter and Native side
class Onegini {
  static const String startAppMethod = 'startApp';
  static const String getResourceMethod = 'getResource';
  static const String registrationMethod = 'registration';
  static const String getInfoMethod = "getInfo";
  static const MethodChannel oneginiChannel =
      const MethodChannel('com.onegini/sdk');

  Future<bool> startApplication() async {
    var appStarted = false;
    try {
      appStarted = await oneginiChannel.invokeMethod(startAppMethod);
    } on PlatformException catch (error) {
      throw error;
    }
    return appStarted;
  }

  Future<void> fetchResource() async {
    try {
      var resource = await oneginiChannel
          .invokeMethod(getResourceMethod, {"username": "stanislaw@onegini.com"});
      print(resource);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Future<String> registration() async {
    try {
      var userId = await oneginiChannel
          .invokeMethod(registrationMethod);
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
