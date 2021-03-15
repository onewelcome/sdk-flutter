import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/authentication_methods.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/registration_methods.dart';
import 'package:onegini/resources_methods.dart';


class Onegini {


  Onegini._privateConstructor();

  static final Onegini _instance = Onegini._privateConstructor();

  static Onegini get instance => _instance;

  final MethodChannel channel = const MethodChannel('onegini');
  OneginiEventListener _eventListener;

  RegistrationMethods registrationMethods = RegistrationMethods();
  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  ResourcesMethods resourcesMethods = ResourcesMethods();



  setEventContext(BuildContext context) {
    _eventListener.context = context;
  }

  Future<String> startApplication(
      OneginiEventListener eventListener) async {
    _eventListener = eventListener;
    try {
      String removedUserProfiles =
          await channel.invokeMethod(Constants.startAppMethod);
      if (removedUserProfiles != null) eventListener.listen();
      return removedUserProfiles;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> singleSingOn(String url) async {
    try {
      var oneginiAppToWebSingleSignOn = await channel
          .invokeMethod(Constants.getSingleSignOnMethod, <String, String>{
        'url': url,
      });
      print(oneginiAppToWebSingleSignOn);
      return oneginiAppToWebSingleSignOn;
    } on PlatformException catch (error) {
      throw error;
    }
  }


  Future<String> sendPin(String pinCode, bool isAuth) async {
    try {
      var userId = await channel.invokeMethod(Constants.getSendPinMethod,
          <String, dynamic>{'pin': pinCode, 'isAuth': isAuth});
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }




  Future<void> changePin(BuildContext context) async {
    _eventListener?.context = context;
    try {
      await channel.invokeMethod(Constants.changePin);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> sendQrCodeData(String data) async {
    try {
      var isSuccess = await channel
          .invokeMethod(Constants.otpQrCodeResponse, <String, dynamic>{
        'data': data,
      });
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }


}
