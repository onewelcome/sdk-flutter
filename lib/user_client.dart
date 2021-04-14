import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'model/onegini_list_response.dart';
import 'onegini.dart';

/// The class with basic methods available to the developer.
class UserClient {
  /// Start registration flow.
  ///
  /// If [identityProviderId] is null, starts standard browser registration.
  /// Use your [scopes] for registration. By default it is "read".
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

  /// Returns a list of available identity providers.
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

  /// Deletes the user.
  Future<bool> deregisterUser() async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.deregisterUserMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Returns a list of authenticators registered and available to the user.
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

  /// Starts authentication flow.
  ///
  /// If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
  /// Usually it is Pin authenticator.
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

  /// Returns a list of authenticators available to the user, but not yet registered.
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

  /// Starts change pin flow.
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

  /// Registers authenticator from [getNotRegisteredAuthenticators] list.
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

  /// Method for log out.
  Future<bool> logout() async {
    try {
      var isSuccess =
          await Onegini.instance.channel.invokeMethod(Constants.logout);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Starts mobile authentication on web by OTP.
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

  /// Single sign on the user web page.
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

  /// User profiles
  Future<String> fetchUserProfiles() async {
    try {
      var profiles = await Onegini.instance.channel
          .invokeMethod(Constants.userProfiles);
      return profiles;
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
