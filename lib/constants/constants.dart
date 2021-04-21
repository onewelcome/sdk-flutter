class Constants {
  /// Onegini methods
  static const String startAppMethod = 'startApp';

  //registration
  static const String registerUser = 'registerUser';
  static const String cancelRegistrationMethod = "cancelRegistration";
  static const String getIdentityProvidersMethod = "getIdentityProviders";
  static const String denyPinRegistrationRequest = "denyPinRegistrationRequest";
  static const String acceptPinRegistrationRequest =
      "acceptPinRegistrationRequest";
  static const String deregisterUserMethod = "deregisterUser";

  //authentication
  static const String authenticateUser = 'authenticateUser';
  static const String getAllNotRegisteredAuthenticators =
      "getAllNotRegisteredAuthenticators";
  static const String getRegisteredAuthenticators =
      "getRegisteredAuthenticators";
  static const String registerAuthenticator = "registerAuthenticator";
  static const String denyPinAuthenticationRequest =
      "denyPinAuthenticationRequest";
  static const String acceptPinAuthenticationRequest =
      "acceptPinAuthenticationRequest";
  static const String logout = 'logout';
  static const String setPreferredAuthenticator = "setPreferredAuthenticator";
  static const String deregisterAuthenticator = "deregisterAuthenticator";

  //fingerprint
  static const String acceptFingerprintAuthenticationRequest =
      'acceptFingerprintAuthenticationRequest';
  static const String denyFingerprintAuthenticationRequest =
      "denyFingerprintAuthenticationRequest";
  static const String fingerprintFallbackToPin = "fingerprintFallbackToPin";

  //otp
  static const String handleMobileAuthWithOtp = "handleMobileAuthWithOtp";
  static const String acceptOtpAuthenticationRequest =
      "acceptOtpAuthenticationRequest";
  static const String denyOtpAuthenticationRequest =
      "denyOtpAuthenticationRequest";

  //resources
  static const String getResource = "getResource";
  static const String getResourceAnonymous = "getResourceAnonymous";
  static const String getImplicitResource ="getImplicitResource";
  static const String getUnauthenticatedResource = "getUnauthenticatedResource";


  //Other
  static const String getAppToWebSingleSignOn = "getAppToWebSingleSignOn";
  static const String changePin = "changePin";
  static const String userProfiles = "userProfiles";
  static const String validatePinWithPolicy = "validatePinWithPolicy";

  //CustomRegistration
  static const String customTwoStepRegistrationReturnSuccess =
      "customTwoStepRegistrationReturnSuccess";
  static const String customTwoStepRegistrationReturnError =
      "customTwoStepRegistrationReturnError";

  /// Onegini events
  static const String eventOpenPin = "eventOpenPin";
  static const String eventOpenPinAuth = "eventOpenPinAuth";
  static const String eventOpenPinAuthenticator = "eventOpenPinAuthenticator";
  static const String eventClosePin = "eventClosePin";
  static const String eventClosePinAuth = "eventClosePinAuth";
  static const String eventNextAuthenticationAttempt =
      "eventNextAuthenticationAttempt";

  static const String eventOpenFingerprintAuth = "eventOpenFingerprintAuth";
  static const String eventReceivedFingerprintAuth =
      "eventReceivedFingerprintAuth";
  static const String eventShowScanningFingerprintAuth =
      "eventShowScanningFingerprintAuth";
  static const String eventCloseFingerprintAuth = "eventCloseFingerprintAuth";

  static const String eventOpenAuthOTP = "eventOpenAuthOtp";
  static const String eventCancelAuthOTP = "eventCancelAuthOtp";
  static const String eventCloseAuthOTP = "eventCloseAuthOtp";

  static const String openCustomTwoStepRegistrationScreen =
      "openCustomTwoStepRegistrationScreen";
  static const String eventError = "eventError";
}
