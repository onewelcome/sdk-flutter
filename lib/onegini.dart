
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/pin_screen.dart';

import 'model/Provider.dart';
import 'model/applicationDetails.dart';
import 'model/clientResource.dart';





class Onegini {

  static BuildContext context;

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
  static const String getIdentityProvidersMethod = "getIdentityProviders";
  static const String registrationWithIdentityProviderMethod = "registrationWithIdentityProvider";
  static const String getClientResourceMethod = "getClientResource";
  static const String getImplicitUserDetailsMethod = "getImplicitUserDetails";
  static const String getSingleSignOnMethod = "singleSignOn";


  static Future<bool> startApplication() async {
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
      if(event == "event_open_pin_confirmation"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PinScreen(confirmation: true,)),
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

  static Future<ApplicationDetails> getApplicationDetails() async {
    try {
      var resource = await _channel
          .invokeMethod(getApplicationDetailsMethod);
      return ApplicationDetails.fromJson(jsonDecode(resource));
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<ClientResource> getClientResource() async {
    try {
      var resource = await _channel
          .invokeMethod(getClientResourceMethod);
      return clientResourceFromJson(resource);
    } on PlatformException catch (error) {
      print(error.details.toString());
      throw error;
    } on Exception catch (error){
      throw error;
    }
  }


  static Future<String> getImplicitUserDetails() async {
    try {
      var resource = await _channel
          .invokeMethod(getImplicitUserDetailsMethod);
      return resource;
    } on PlatformException catch (error) {
      throw error;
    }
  }


  static Future<String> registration(BuildContext context) async {
    Onegini.context = context;
    try {
      var userId = await _channel
          .invokeMethod(registrationMethod);
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<List<Provider>> getIdentityProviders(BuildContext context) async {
    Onegini.context = context;
    try {
      var providers = await _channel
          .invokeMethod(getIdentityProvidersMethod);
      return providerFromJson(providers);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> registrationWithIdentityProvider(String identityProviderId) async {
    try {
      var userId = await _channel
          .invokeMethod(registrationWithIdentityProviderMethod, <String, String>{
      'identityProviderId': identityProviderId,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> singleSingOn() async {
    try {
      await _channel
          .invokeMethod(getSingleSignOnMethod);
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
