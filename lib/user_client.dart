import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/registration_response.dart';
import 'package:onegini/pigeon.dart';

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
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Start browser Registration logic
  Future<void> handleRegisteredUserUrl(BuildContext? context, String? url,
      {WebSignInType signInType = WebSignInType.insideApp}) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel
        .invokeMethod(Constants.handleRegisteredUserUrl, <String, Object?>{
      'url': url,
      'type': signInType.value,
    });
  }

  /// Returns a list of available identity providers.
  Future<List<OneginiListResponse>> getIdentityProviders(
      BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    try {
      var providers = await Onegini.instance.channel
          .invokeMethod(Constants.getIdentityProvidersMethod);
      return responseFromJson(providers);
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Deletes the user.
  Future<bool> deregisterUser(String profileId) async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.deregisterUserMethod, <String, String?>{
        'profileId': profileId,
      });
      return isSuccess ?? false;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
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
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  Future<List<OneginiListResponse>> getAllAuthenticators(
      BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getAllAuthenticators);
      return responseFromJson(authenticators);
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  Future<UserProfile> getAuthenticatedUserProfile(BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    try {
      var userProfile = await Onegini.instance.channel
          .invokeMethod(Constants.getAuthenticatedUserProfile);
      return userProfileFromJson(userProfile);
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Starts authentication flow.
  ///
  /// If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
  /// Usually it is Pin authenticator.
  Future<RegistrationResponse> authenticateUser(
    BuildContext? context,
    String? registeredAuthenticatorId,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      var response = await Onegini.instance.channel
          .invokeMethod(Constants.authenticateUser, <String, String?>{
        'registeredAuthenticatorId': registeredAuthenticatorId,
      });
      return registrationResponseFromJson(response);
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Returns a list of authenticators available to the user, but not yet registered.
  Future<List<OneginiListResponse>> getNotRegisteredAuthenticators(
      BuildContext? context) async {
    try {
      var authenticators = await Onegini.instance.channel
          .invokeMethod(Constants.getAllNotRegisteredAuthenticators);
      return responseFromJson(authenticators);
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Starts change pin flow.
  Future<void> changePin(
    BuildContext? context,
  ) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel.invokeMethod(Constants.changePin);
  }

  /// Registers authenticator from [getNotRegisteredAuthenticators] list.
  Future<void> registerAuthenticator(
      BuildContext? context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel
        .invokeMethod(Constants.registerAuthenticator, <String, String>{
      'authenticatorId': authenticatorId,
    });
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
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
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
      return success ?? false;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  ///Method for log out
  Future<bool> logout() async {
    try {
      var isSuccess =
          await Onegini.instance.channel.invokeMethod(Constants.logout);
      return isSuccess ?? false;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// Starts mobile authentication on web by OTP.
  Future<String?> mobileAuthWithOtp(String data) async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.handleMobileAuthWithOtp, <String, dynamic>{
        'data': data,
      });
      return isSuccess;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
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
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  /// User profiles
  Future<List<UserProfile>> getUserProfiles() async {
    try {
      var profiles = await Onegini.instance.channel
          .invokeMethod(Constants.getUserProfiles);
      return List<UserProfile>.from(json
          .decode(profiles)
          .map((profile) => UserProfile.fromJson(profile)));
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  Future<bool> validatePinWithPolicy(String pin) async {
    try {
      var success = await Onegini.instance.channel.invokeMethod(
          Constants.validatePinWithPolicy, <String, String?>{'pin': pin});
      return success ?? false;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  Future<bool> authenticateDevice(List<String>? scopes) async {
    try {
      var success = await Onegini.instance.channel.invokeMethod(
          Constants.authenticateDevice, <String, dynamic>{'scope': scopes});

      return success ?? false;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
    }
  }

  Future<String> authenticateUserImplicitly(
      String profileId, List<String>? scopes) async {
    try {
      var userProfileId = await Onegini.instance.channel.invokeMethod(
          Constants.authenticateUserImplicitly,
          <String, dynamic>{'profileId': profileId, 'scopes': scopes});
      return userProfileId;
    } on TypeError catch (error) {
      throw PlatformException(
          code: Constants.wrapperTypeError.code.toString(),
          message: Constants.wrapperTypeError.message,
          stacktrace: error.stackTrace?.toString());
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
