import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/model/application_details.dart';
import 'package:onegini/model/client_resource.dart';
import 'package:onegini/model/onegini_identity_provider.dart';
import 'package:onegini/onegini_event_listener.dart';

class Onegini {
  static OneginiEventListener _eventListener;

  static const MethodChannel _channel = const MethodChannel('onegini');

  static Future<String> get platformVersion async {
    final String version =
        await _channel.invokeMethod(Constants.getPlatformVersion);
    return version;
  }

  static Future<bool> startApplication(
      OneginiEventListener eventListener) async {
    _eventListener = eventListener;
    var appStarted = false;
    try {
      appStarted = await _channel.invokeMethod(Constants.startAppMethod);
    } on PlatformException catch (error) {
      throw error;
    }
    if (appStarted) eventListener.listen();
    return appStarted;
  }

  static Future<ApplicationDetails> getApplicationDetails() async {
    try {
      var resource =
          await _channel.invokeMethod(Constants.getApplicationDetailsMethod);
      return ApplicationDetails.fromJson(jsonDecode(resource));
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<ClientResource> getClientResource() async {
    try {
      var resource =
          await _channel.invokeMethod(Constants.getClientResourceMethod);
      return clientResourceFromJson(resource);
    } on PlatformException catch (error) {
      print(error.details.toString());
      throw error;
    } on Exception catch (error) {
      throw error;
    }
  }

  static Future<String> getImplicitUserDetails() async {
    try {
      var resource =
          await _channel.invokeMethod(Constants.getImplicitUserDetailsMethod);
      return resource;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> registration(BuildContext context,String scopes) async {
    _eventListener?.context = context;
    try {
      var userId = await _channel.invokeMethod(Constants.registrationMethod, <String, String>{
        'scopes': scopes
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<List<OneginiIdentityProvider>> getIdentityProviders(
      BuildContext context) async {
    _eventListener?.context = context;
    try {
      var providers =
          await _channel.invokeMethod(Constants.getIdentityProvidersMethod);
      return providerFromJson(providers);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> registrationWithIdentityProvider(
      String identityProviderId,String scopes) async {
    try {
      var userId = await _channel.invokeMethod(
          Constants.registrationWithIdentityProviderMethod, <String, String>{
        'identityProviderId': identityProviderId,
        'scopes': scopes
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> singleSingOn() async {
    try {
      await _channel.invokeMethod(Constants.getSingleSignOnMethod);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<bool> logOut() async {
    try {
      var isSuccess = await _channel.invokeMethod(Constants.logOutMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<bool> deregisterUser() async {
    try {
      var isSuccess =
          await _channel.invokeMethod(Constants.deregisterUserMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> sendPin(String pinCode) async {
    try {
      var userId = await _channel
          .invokeMethod(Constants.getSendPinMethod, <String, dynamic>{
        'pin': pinCode,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
