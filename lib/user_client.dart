import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/registration_response.dart';

import 'constants/constants.dart';
import 'model/oneginiAppToWebSingleSignOn.dart';
import 'model/onegini_list_response.dart';
import 'onegini.dart';

///Сlass with basic methods available to the developer.
class UserClient {
  ///Start registration flow.
  ///
  /// If [identityProviderId] is null, starts standard browser registration.
  /// Use your [scopes] for registration. By default it is "read".
  Future<RegistrationResponse> registerUser(
    BuildContext? context,
    String? identityProviderId,
    List<String>? scopes,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.registerUser, <String, dynamic>{
        'scopes': scopes,
        'identityProviderId': identityProviderId,
      });
      return registrationResponseFromJson(response);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> handleRegisteredUserUrl(BuildContext? context, String? url,
      {WebSignInType signInType = WebSignInType.insideApp}) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.handleRegisteredUserUrl, <String, Object?>{
        'url': url,
        'type': signInType.value,
      });
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Returns a list of available identity providers.
  Future<List<OneginiListResponse>> getIdentityProviders(
      BuildContext? context) async {
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
  Future<bool> deregisterUser(String profileId) async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.deregisterUserMethod, <String, String?>{
        'profileId': profileId,
      });
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Returns a list of authenticators registered and available to the user.
  Future<List<OneginiListResponse>> getRegisteredAuthenticators(
      BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getRegisteredAuthenticators);
      return responseFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<List<OneginiListResponse>> getAllAuthenticators(
      BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getAllAuthenticators);
      return responseFromJson(authenticators);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Starts authentication flow.
  ///
  /// If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
  /// Usually it is Pin authenticator.
  Future<RegistrationResponse> authenticateUser(
    BuildContext context,
    String? registeredAuthenticatorId,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.authenticateUser, <String, String?>{
        'registeredAuthenticatorId': registeredAuthenticatorId,
      });
      return registrationResponseFromJson(response);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Returns a list of authenticators available to the user, but not yet registered.
  Future<List<OneginiListResponse>> getNotRegisteredAuthenticators(
      BuildContext? context) async {
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
    BuildContext? context,
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
      BuildContext? context, String authenticatorId) async {
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

  ///Set preferred authenticator
  Future<bool> setPreferredAuthenticator(
      BuildContext? context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);
    try {
      var data = await Onegini.instance.channel
          .invokeMethod(Constants.setPreferredAuthenticator, <String, String>{
        'authenticatorId': authenticatorId,
      });
      return data;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<bool> deregisterAuthenticator(
      BuildContext? context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);
    try {
      var success = await Onegini.instance.channel
          .invokeMethod(Constants.deregisterAuthenticator, <String, String>{
        'authenticatorId': authenticatorId,
      });
      return success;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  ///Method for log out
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
  Future<bool> handleMobileAuthWithOtp(String data) async {
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

 Future<bool> enrollUserForMobileAuth() async {
   try {
     var isSuccess = await Onegini.instance.channel
         .invokeMethod(Constants.handleMobileAuthWithOtp);
     return isSuccess;
   } on PlatformException catch (error) {
     throw error;
   }
 }

  /// Single sign on the user web page.
  Future<OneginiAppToWebSingleSignOn> getAppToWebSingleSignOn(
      String url) async {
    try {
      var oneginiAppToWebSingleSignOn = await Onegini.instance.channel
          .invokeMethod(Constants.getAppToWebSingleSignOn, <String, String>{
        'url': url,
      });
      return oneginiAppToWebSingleSignOnFromJson(oneginiAppToWebSingleSignOn);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// User profiles
  Future<List<UserProfile>> fetchUserProfiles() async {
    try {
      var profiles =
          await Onegini.instance.channel.invokeMethod(Constants.userProfiles);
      return List<UserProfile>.from(
          json.decode(profiles).map((x) => UserProfile.fromJson(x)));
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<bool> validatePinWithPolicy(String pin) async {
    try {
      var success = await Onegini.instance.channel.invokeMethod(
          Constants.validatePinWithPolicy, <String, String?>{'pin': pin});
      return success;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> getAccessToken(String pin) async {
    try {
      var accessToken =
          await Onegini.instance.channel.invokeMethod(Constants.getAccessToken);
      return accessToken;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<UserProfile> getAuthenticatedUserProfile(String pin) async {
    try {
      var userProfile = await Onegini.instance.channel
          .invokeMethod(Constants.getAuthenticatedUserProfile);

      return UserProfile.fromJson(json.decode(userProfile));
    } on PlatformException catch (error) {
      throw error;
    }
  }
}

enum WebSignInType {
  insideApp,
  safari,
}

extension WebSignInTypeExtension on WebSignInType {
  int get value {
    switch (this) {
      case WebSignInType.safari:
        return 1;
      default:
        return 0;
    }
  }
}
