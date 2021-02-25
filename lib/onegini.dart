import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';
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
      String removedUserProfiles = await _channel.invokeMethod(Constants.startAppMethod);
      print(removedUserProfiles);
      if(removedUserProfiles != null){
        appStarted = true;
      }
    } on PlatformException catch (error) {
      throw error;
    }
    if (appStarted) eventListener.listen();
    return appStarted;
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

  static Future<List<OneginiIdentityProvider>> getRegisteredAuthenticators(
      BuildContext context) async {
    _eventListener?.context = context;
    try {
      var authenticators =
      await _channel.invokeMethod(Constants.getRegisteredAuthenticators);
      return providerFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> authenticationWithRegisteredAuthenticators(
      String registeredAuthenticatorsId) async {
    try {
      var userId = await _channel.invokeMethod(
          Constants.authenticateWithRegisteredAuthentication, <String, String>{
        'registeredAuthenticatorsId': registeredAuthenticatorsId,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }
  static activateFingerprintSensor(BuildContext context) async {
    _eventListener?.context = context;
    try {
      await _channel.invokeMethod(Constants.fingerprintActivationSensor);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> registerFingerprint(BuildContext context) async {
    _eventListener?.context = context;
    try {
      String data = await _channel.invokeMethod(Constants.registerFingerprintAuthenticator);
      return data;
    } on PlatformException catch (error) {
      throw error;
    }
  }



  static Future<String> pinAuthentication(BuildContext context) async {
    _eventListener?.context = context;
    try {
      var userId = await _channel.invokeMethod(Constants.pinAuthentication);
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }



  static Future<void> singleSingOn() async {
    try {
      var oneginiAppToWebSingleSignOn =  await _channel.invokeMethod(Constants.getSingleSignOnMethod);
      //todo use oneginiAppToWebSingleSignOn
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

  static Future<String> sendPin(String pinCode,bool isAuth) async {
    try {
      var userId = await _channel
          .invokeMethod(Constants.getSendPinMethod, <String, dynamic>{
        'pin': pinCode,
        'isAuth' : isAuth
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> cancelRegistration() async {
    try{
       await _channel.invokeMethod(Constants.cancelRegistrationMethod);
    }on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> cancelAuth() async {
    try{
      await _channel.invokeMethod(Constants.cancelPinAuth);
    }on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> changePin(BuildContext context) async {
    _eventListener?.context = context;
    try{
      await _channel.invokeMethod(Constants.changePin);
    }on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> sendQrCodeData(String data) async {
    try {
      await _channel
          .invokeMethod(Constants.otpQrCodeResponse, <String, dynamic>{
        'data': data,

      });
    } on PlatformException catch (error) {
      throw error;
    }
  }

}
