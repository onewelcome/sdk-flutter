import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'model/onegini_list_response.dart';
import 'onegini.dart';

class UserClient {

  Future<String> registerUser(
    BuildContext context,
    String? identityProviderId,
    String scopes,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      var userId = await Onegini.instance.channel
          .invokeMethod(Constants.registerUser, <String, String?>{
        'scopes': scopes,
        'identityProviderId': identityProviderId,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<List<OneginiListResponse>> getIdentityProviders(
      BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      var providers = await Onegini.instance.channel
          .invokeMethod(Constants.getIdentityProvidersMethod);
      return responseFromJson(providers);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<bool> deregisterUser() async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.deregisterUserMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<List<OneginiListResponse>> getRegisteredAuthenticators(
      BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getRegisteredAuthenticators);
      return responseFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> authenticateUser(
    BuildContext context,
    String? registeredAuthenticatorId,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      var userId = await Onegini.instance.channel
          .invokeMethod(Constants.authenticateUser, <String, String?>{
        'registeredAuthenticatorId': registeredAuthenticatorId,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<List<OneginiListResponse>> getNotRegisteredAuthenticators(
      BuildContext context) async {
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getAllNotRegisteredAuthenticators);
      return responseFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> changePin(
    BuildContext context,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel.invokeMethod(Constants.changePin);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> registerAuthenticator(
      BuildContext context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);
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

  Future<bool> logout() async {
    try {
      var isSuccess =
          await Onegini.instance.channel.invokeMethod(Constants.logout);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> mobileAuthWithOtp(String data) async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.handleMobileAuthWithOtp, <String, dynamic>{
        'data': data,
      });
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> getAppToWebSingleSignOn(String url) async {
    try {
      var oneginiAppToWebSingleSignOn = await Onegini.instance.channel
          .invokeMethod(Constants.getAppToWebSingleSignOn, <String, String>{
        'url': url,
      });
      print(oneginiAppToWebSingleSignOn);
      return oneginiAppToWebSingleSignOn;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
