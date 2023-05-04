import 'dart:async';

import 'package:onegini/onegini.gen.dart';

///Сlass with basic methods available to the developer.
class UserClient {
  final UserClientApi api;
  UserClient(this.api);

  ///Start registration flow.
  ///
  /// If [identityProviderId] is null, starts standard browser registration.
  /// Use your [scopes] for registration. By default it is "read".
  Future<OWRegistrationResponse> registerUser(
    String? identityProviderId,
    List<String>? scopes,
  ) async {
    return await api.registerUser(identityProviderId, scopes);
  }

  /// Start browser Registration logic
  Future<void> handleRegisteredUserUrl(String url,
      {WebSignInType signInType = WebSignInType.insideApp}) async {
    await api.handleRegisteredUserUrl(url, signInType.value);
  }

  /// Returns a list of available identity providers.
  Future<List<OWIdentityProvider>> getIdentityProviders() async {
    final providers = await api.getIdentityProviders();
    return providers.whereType<OWIdentityProvider>().toList();
  }

  /// Deletes the user.
  Future<void> deregisterUser(String profileId) async {
    await api.deregisterUser(profileId);
  }

  Future<OWUserProfile> getAuthenticatedUserProfile() async {
    return await api.getAuthenticatedUserProfile();
  }

  /// Starts authentication flow.
  ///
  /// If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
  /// Usually it is Pin authenticator.
  Future<OWRegistrationResponse> authenticateUser(
    String profileId,
    OWAuthenticatorType? authenticatorType,
  ) async {
    if (authenticatorType != null) {
      return await api.authenticateUser(profileId, authenticatorType);
    } else {
      return await api.authenticateUserPreferred(profileId);
    }
  }

  /// Starts change pin flow.
  Future<void> changePin() async {
    await api.changePin();
  }

  ///Set preferred authenticator
  /// todo removed boolean return update docu
  Future<void> setPreferredAuthenticator(
      OWAuthenticatorType authenticatorType) async {
    await api.setPreferredAuthenticator(authenticatorType);
  }

  // Gets the preferred authenticator for the given profile
  Future<OWAuthenticator> getPreferredAuthenticator(String profileId) async {
    return await api.getPreferredAuthenticator(profileId);
  }

  Future<void> deregisterBiometricAuthenticator() async {
    await api.deregisterBiometricAuthenticator();
  }

  Future<void> registerBiometricAuthenticator() async {
    await api.registerBiometricAuthenticator();
  }

  Future<OWAuthenticator> getBiometricAuthenticator(String profileId) async {
    return await api.getBiometricAuthenticator(profileId);
  }

  /// Method for log out
  Future<void> logout() async {
    await api.logout();
  }

  /// Enroll for MobileAuthentication (enable OTP)
  Future<void> enrollMobileAuthentication() async {
    await api.enrollMobileAuthentication();
  }

  /// Respond to mobile authentication with OTP
  Future<void> handleMobileAuthWithOtp(String data) async {
    await api.handleMobileAuthWithOtp(data);
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
