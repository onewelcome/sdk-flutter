// Dev note: When editing these error codes, make sure to update them in the native wrapper code aswel.

/// Errors from the flutter sdk, some of these errors can only occur on a single platform.
class WrapperErrorCodes {
  static const String genericError = "8000";
  static const String notAuthenticatedUser = "8040";
  static const String notAuthenticatedImplicit = "8041";
  static const String notFoundUserProfile = "8042";
  static const String notFoundAuthenticator = "8043";
  static const String notFoundIdentityProvider = "8044";

  /// Android only
  static const String notFoundSecurityController = "8045";

  static const String httpRequestErrorInternal = "8046";
  static const String httpRequestErrorCode = "8047";

  /// iOS only
  static const String httpRequestErrorNoResponse = "8048";

  /// Android only
  static const String onewelcomeSdkNotInitialized = "8049";

  static const String invalidUrl = "8050";
  static const String notInProgressCustomRegistration = "8051";
  static const String notInProgressAuthentication = "8052";
  static const String notInProgressOtpAuthentication = "8053";
  static const String notInProgressPinCreation = "8054";
  static const String notInProgressFingerprintAuthentication = "8055";

  /// iOS only. Android will throw actionAlreadyInProgress
  static const String alreadyInProgressMobileAuth = "8056";

  static const String actionNotAllowedCustomRegistrationCancel = "8057";
  static const String actionNotAllowedBrowserRegistrationCancel = "8058";

  /// Android only
  static const String configError = "8059";

  static const String biometricAuthenticationNotAvailable = "8060";
}

const String networkConnectivityProblem = "9000";

/// Error from the native sdk's, some of these errors can only occur on a single platform.
class PlatformErrorCodes {
  static const String networkConnectivityProblem = "9000";
  static const String serverNotReachable = "9001";
  static const String deviceDeregistered = "9002";
  static const String userDeregistered = "9003";
  static const String outdatedApp = "9004";
  static const String outdatedOs = "9005";
  static const String actionCanceled = "9006";
  static const String actionAlreadyInProgress = "9007";
  static const String deviceRegistrationError = "9008";

  /// iOS only
  static const String authenticationErrorInvalidPin = "9009";

  static const String userNotAuthenticated = "9010";
  static const String pinBlacklisted = "9011";
  static const String pinIsASequence = "9012";
  static const String pinUsesSimilarDigits = "9013";
  static const String wrongPinLength = "9014";
  static const String invalidAuthenticator = "9015";
  static const String deviceAlreadyEnrolled = "9016";
  static const String enrollmentNotAvailable = "9017";
  static const String userAlreadyEnrolled = "9018";
  static const String userDisenrolled = "9020";
  static const String mobileAuthenticationNotEnrolled = "9021";
  static const String authenticatorDeregistered = "9022";

  /// Android only
  static const String mobileAuthenticationDisenrolled = "9023";

  static const String dataStorageNotAvailable = "9024";

  /// iOS only
  static const String genericErrorUnrecoverableDataState = "9025";

  /// iOS only
  static const String userNotAuthenticatedImplicitly = "9026";

  static const String customAuthenticatorFailure = "9027";

  /// iOS only
  static const String alreadyHandled = "9029";

  static const String authenticationErrorBiometricAuthenticatorFailure = "9030";

  /// Android only
  static const String invalidDatetime = "9031";

  static const String generalError = "10000";
  static const String configurationError = "10001";
  static const String invalidState = "10002";
  static const String localDeregistration = "10003";
  static const String authenticatorAlreadyRegistered = "10004";

  /// Android only
  static const String fidoAuthenticationDisabledDeprecated = "10005";

  static const String authenticatorNotSupported = "10006";
  static const String authenticatorNotRegistered = "10007";
  static const String authenticatorPinDeregistrationNotPossible = "10008";
  static const String localLogout = "10009";

  /// iOS only
  static const String fetchInvalidMethod = "10010";

  static const String deviceNotAuthenticated = "10012";
  static const String mobileAuthenticationRequestNotFound = "10013";
  static const String invalidRequest = "10015";

  /// Android only
  static const String fidoServerNotReachableDeprecated = "10016";

  static const String customAuthenticationDisabled = "10017";
  static const String notHandleable = "10018";

  /// iOS only
  static const String fetchInvalidHeaders = "10019";

  /// Android only
  static const String invalidIdentityProvider = "10020";

  static const String customRegistrationExpired = "10021";
  static const String customRegistrationFailure = "10022";
  static const String singleSignOnDisabled = "10023";
  static const String appIntegrityFailure = "10024";
}
