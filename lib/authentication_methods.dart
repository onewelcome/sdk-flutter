import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'model/onegini_identity_provider.dart';
import 'onegini.dart';

class AuthenticationMethods {
  Future<List<OneginiIdentityProvider>> getRegisteredAuthenticators(
      BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getRegisteredAuthenticators);
      return providerFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> authenticationWithRegisteredAuthenticators(
      String registeredAuthenticatorsId) async {
    try {
      var userId = await Onegini.instance.channel.invokeMethod(
          Constants.authenticateWithRegisteredAuthentication, <String, String>{
        'registeredAuthenticatorsId': registeredAuthenticatorsId,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<List<OneginiIdentityProvider>> getNotRegisteredAuthenticators(
      BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getAllNotRegisteredAuthenticators);
      return providerFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> registeredAuthenticator(String authenticatorId) async {
    try {
      var data = await Onegini.instance.channel
          .invokeMethod(Constants.registerAuthenticator, <String, String>{
        'authenticatorId': authenticatorId,
      });
      return data;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> activateFingerprintSensor(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.fingerprintActivationSensor);
    } on PlatformException catch (error) {
      throw error;
    }
  }


  Future<String> pinAuthentication(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      var userId = await Onegini.instance.channel
          .invokeMethod(Constants.pinAuthentication);
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> cancelAuth(bool isPin) async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.cancelPinAuth, <String, dynamic>{
        'isPin': isPin,
      });
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<bool> logOut() async {
    try {
      var isSuccess =
          await Onegini.instance.channel.invokeMethod(Constants.logOutMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> acceptOTPAuth(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel.invokeMethod(Constants.acceptOTPAuth);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> denyOTPAuth(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel.invokeMethod(Constants.denyOTPAuth);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
