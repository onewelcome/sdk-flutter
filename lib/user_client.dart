import 'dart:convert';

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
  final api = UserClientApi();

  ///Start registration flow.
  ///
  /// If [identityProviderId] is null, starts standard browser registration.
  /// Use your [scopes] for registration. By default it is "read".
  Future<OWRegistrationResponse> registerUser(
    BuildContext? context,
    String? identityProviderId,
    List<String>? scopes,
  ) async {
    Onegini.instance.setEventContext(context);
    return api.registerUser(identityProviderId, scopes);
  }

  /// Start browser Registration logic
  Future<void> handleRegisteredUserUrl(BuildContext? context, String url,
      {WebSignInType signInType = WebSignInType.insideApp}) async {
    Onegini.instance.setEventContext(context);
    await api.handleRegisteredUserUrl(url, signInType.value);
  }

  /// Returns a list of available identity providers.
  Future<List<OWIdentityProvider>> getIdentityProviders(
      BuildContext? context) async {
    Onegini.instance.setEventContext(context);

    final providers = await api.getIdentityProviders();
    return providers.whereType<OWIdentityProvider>().toList();
  }

  /// Deletes the user.
  Future<void> deregisterUser(String profileId) async {
    await api.deregisterUser(profileId);
  }

  /// Returns a list of authenticators registered and available to the user.
  Future<List<OWAuthenticator>> getRegisteredAuthenticators(
      BuildContext? context, String profileId) async {
    Onegini.instance.setEventContext(context);

    final registeredAuthenticators =
        await api.getRegisteredAuthenticators(profileId);
    return registeredAuthenticators.whereType<OWAuthenticator>().toList();
  }

  Future<List<OWAuthenticator>> getAllAuthenticators(
      BuildContext? context, String profileId) async {
    Onegini.instance.setEventContext(context);

    final allAuthenticators = await api.getAllAuthenticators(profileId);
    return allAuthenticators.whereType<OWAuthenticator>().toList();
  }

  Future<OWUserProfile> getAuthenticatedUserProfile() async {
    return await api.getAuthenticatedUserProfile();
  }

  /// Starts authentication flow.
  ///
  /// If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
  /// Usually it is Pin authenticator.
  Future<OWRegistrationResponse> authenticateUser(
    BuildContext? context,
    String profileId,
    String? registeredAuthenticatorId,
  ) async {
    Onegini.instance.setEventContext(context);

    return await api.authenticateUser(profileId, registeredAuthenticatorId);
  }

  /// Returns a list of authenticators available to the user, but not yet registered.
  Future<List<OWAuthenticator>> getNotRegisteredAuthenticators(
      BuildContext? context, String profileId) async {
    final notRegisteredAuthenticators =
        await api.getNotRegisteredAuthenticators(profileId);
    return notRegisteredAuthenticators.whereType<OWAuthenticator>().toList();
  }

  /// Starts change pin flow.
  Future<void> changePin(
    BuildContext? context,
  ) async {
    Onegini.instance.setEventContext(context);

    await api.changePin();
  }

  /// Registers authenticator from [getNotRegisteredAuthenticators] list.
  Future<void> registerAuthenticator(
      BuildContext? context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);

    await api.registerAuthenticator(authenticatorId);
  }

  ///Set preferred authenticator
  /// todo removed boolean return update docu
  Future<void> setPreferredAuthenticator(
      BuildContext? context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);

    await api.setPreferredAuthenticator(authenticatorId);
  }

  /// todo removed boolean return update docu
  Future<void> deregisterAuthenticator(
      BuildContext? context, String authenticatorId) async {
    Onegini.instance.setEventContext(context);

    await api.deregisterAuthenticator(authenticatorId);
  }

  ///Method for log out
  /// todo removed boolean return update docu
  Future<void> logout() async {
    await api.logout();
  }

  /// Starts mobile authentication on web by OTP.
  Future<String?> mobileAuthWithOtp(String data) async {
    return await api.mobileAuthWithOtp(data);
  }

  /// Single sign on the user web page.
  Future<OWAppToWebSingleSignOn> getAppToWebSingleSignOn(String url) async {
    return await api.getAppToWebSingleSignOn(url);
  }

  // Get Access Token
  Future<String> getAccessToken() async {
    return await api.getAccessToken();
  }

  // Redirect url
  Future<String> getRedirectUrl() async {
    return await api.getRedirectUrl();
  }

  /// User profiles
  Future<List<OWUserProfile>> getUserProfiles() async {
    final userProfiles = await api.getUserProfiles();
    return userProfiles.whereType<OWUserProfile>().toList();
  }

  /// todo removed boolean return update docu
  Future<void> validatePinWithPolicy(String pin) async {
    await api.validatePinWithPolicy(pin);
  }

  /// todo removed boolean return update docu
  Future<void> authenticateDevice(List<String>? scopes) async {
    await api.authenticateDevice(scopes);
  }

  /// todo removed string return update docu
  Future<void> authenticateUserImplicitly(
      String profileId, List<String>? scopes) async {
    await api.authenticateUserImplicitly(profileId, scopes);
  }
}

// TODO We could also get rid of this but leave this for now.
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
