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

  static setEventContext(BuildContext context) {
    _eventListener.context = context;
  }

  static Future<String> startApplication(
      OneginiEventListener eventListener) async {
    _eventListener = eventListener;
    try {
      String removedUserProfiles =
          await _channel.invokeMethod(Constants.startAppMethod);
      if (removedUserProfiles != null) eventListener.listen();
      return removedUserProfiles;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> registration(
      BuildContext context, String scopes) async {
    _eventListener?.context = context;
    try {
      var userId = await _channel.invokeMethod(
          Constants.registrationMethod, <String, String>{'scopes': scopes});
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
      String identityProviderId, String scopes) async {
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

  static Future<List<OneginiIdentityProvider>> getNotRegisteredAuthenticators(
      BuildContext context) async {
    _eventListener?.context = context;
    try {
      var authenticators = await _channel
          .invokeMethod(Constants.getAllNotRegisteredAuthenticators);
      return providerFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> registeredAuthenticator(String authenticatorId) async {
    try {
      var data = await _channel
          .invokeMethod(Constants.registerAuthenticator, <String, String>{
        'authenticatorId': authenticatorId,
      });
      return data;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> activateFingerprintSensor(BuildContext context) async {
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
      String data = await _channel
          .invokeMethod(Constants.registerFingerprintAuthenticator);
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

  static Future<String> singleSingOn(String url) async {
    try {
      var oneginiAppToWebSingleSignOn = await _channel
          .invokeMethod(Constants.getSingleSignOnMethod, <String, String>{
        'url': url,
      });
      print(oneginiAppToWebSingleSignOn);
      return oneginiAppToWebSingleSignOn;
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

  static Future<String> sendPin(String pinCode, bool isAuth) async {
    try {
      var userId = await _channel.invokeMethod(Constants.getSendPinMethod,
          <String, dynamic>{'pin': pinCode, 'isAuth': isAuth});
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> cancelRegistration() async {
    try {
      await _channel.invokeMethod(Constants.cancelRegistrationMethod);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> cancelAuth(bool isPin) async {
    try {
      await _channel.invokeMethod(Constants.cancelPinAuth, <String, dynamic>{
        'isPin': isPin,
      });
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> changePin(BuildContext context) async {
    _eventListener?.context = context;
    try {
      await _channel.invokeMethod(Constants.changePin);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<bool> isUserNotRegisteredFingerprint() async {
    try {
      var isUserNotRegisteredFingerprint =
          await _channel.invokeMethod(Constants.isUserNotRegisteredFingerprint);
      return isUserNotRegisteredFingerprint;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> sendQrCodeData(String data) async {
    try {
      var isSuccess = await _channel
          .invokeMethod(Constants.otpQrCodeResponse, <String, dynamic>{
        'data': data,
      });
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> acceptOTPAuth(BuildContext context) async {
    _eventListener.context = context;
    try {
      await _channel.invokeMethod(Constants.acceptOTPAuth);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<void> denyOTPAuth(BuildContext context) async {
    _eventListener.context = context;
    try {
      await _channel.invokeMethod(Constants.denyOTPAuth);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> getResourceWithAnonymousResourceOkHttpClient(String path,String scope,{Map<String,String> headers,String method,String encoding,String body, }) async {
    try {
     var response = await _channel.invokeMethod(Constants.getResourceAnonymous, <String, dynamic>{
       'path': path,
       'scope':scope,
       'headers' : headers,
       'method' : method,
       'encoding':encoding,
       'body':body
     });
     return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> getResourceWithResourceOkHttpClient(String path,{Map<String,String> headers,String method,String encoding,String body, }) async {
    try {
      var response =  await _channel.invokeMethod(Constants.getResource,<String, dynamic>{
        'path': path,
        'headers' : headers,
        'method' : method,
        'encoding':encoding,
        'body':body
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  static Future<String> getResourceWithImplicitResourceOkHttpClient(String path,String scope,{Map<String,String> headers,String method,String encoding,String body, }) async {

    try {
      var response = await _channel.invokeMethod(Constants.getImplicitResource,<String, dynamic>{
        'path': path,
        'scope':scope,
        'headers' : headers,
        'method' : method,
        'encoding':encoding,
        'body':body
      });
      return response;
    } on PlatformException catch (error) {
      throw error;
    }
  }

}
