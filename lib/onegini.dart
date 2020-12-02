
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/pin_screen.dart';




class Onegini {

  static const MethodChannel _channel =
      const MethodChannel('onegini');

  static const EventChannel _eventChannel =
      const EventChannel("onegini_events");


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static const String startAppMethod = 'startApp';
  static const String getApplicationDetailsMethod = 'getApplicationDetails';
  static const String registrationMethod = 'registration';
  static const String logOutMethod = 'logOut';
  static const String getInfoMethod = "getInfo";
  static const String getSendPinMethod = "sendPin";
  static const String deregisterUserMethod = "deregisterUser";
  static const String registrationCustomIdentityProviderMethod = "registrationCustomIdentityProvider";
  static const String getClientResourceMethod = "getClientResource";
  static const String getImplicitUserDetailsMethod = "getImplicitUserDetails";


  static Future<bool> startApplication(BuildContext context) async {
    var appStarted = false;
    try {
      appStarted = await _channel.invokeMethod(startAppMethod);
    } on PlatformException catch (error) {
      throw error;
    }
    if(appStarted)
    _eventChannel.receiveBroadcastStream().listen((event) {
      if(event == "event_open_pin"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PinScreen()),
        );
      }
      if(event == "event_close_pin"){
        Navigator.of(context).pop();
      }
    }).onError((error){
      print(error.toString());
    });
    return appStarted;
  }

  static Future<void> getApplicationDetails() async {
    try {
      var resource = await _channel
          .invokeMethod(getApplicationDetailsMethod, {"username": "stanislaw@onegini.com"});
      print(resource);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  static Future<void> getClientResource() async {
    try {
      var resource = await _channel
          .invokeMethod(getClientResourceMethod);
    } on PlatformException catch (error) {
      print(error);
    }
  }


  static Future<void> getImplicitUserDetails() async {
    try {
      var resource = await _channel
          .invokeMethod(getImplicitUserDetailsMethod);
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

  static Future<String> registrationCustomIdentityProvider() async {
    try {
      var userId = await _channel
          .invokeMethod(registrationCustomIdentityProviderMethod);
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }


  static Future<bool> logOut() async {
    try {
      var isSuccess = await _channel
          .invokeMethod(logOutMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }


  static Future<bool> deregisterUser() async {
    try {
      var isSuccess = await _channel
          .invokeMethod(deregisterUserMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }


  static Future<String> sendPin(String pinCode) async {
    try {
      var userId = await _channel
          .invokeMethod(getSendPinMethod ,<String, dynamic>{
        'pin': pinCode,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

}
