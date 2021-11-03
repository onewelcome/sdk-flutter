/// The class with constant values.
///
/// Contains names of methods that Flutter calls on native code, and events that comes back to Flutter.
class Constants {
  //#region Onegini methods

  /// Start app method name
  static const String startAppMethod = 'startApp';

  // Registration

  /// Register user method name
  static const String registerUser = 'registerUser';
  static const String handleRegisteredUserUrl = 'handleRegisteredUserUrl';
  static const String cancelRegistrationMethod = "cancelRegistration";

  /// Get identity providers method name
  static const String getIdentityProvidersMethod = "getIdentityProviders";

  /// Accept pin registration request method name
  static const String acceptPinRegistrationRequest =
      "acceptPinRegistrationRequest";

  /// Deny pin registration request method name
  static const String denyPinRegistrationRequest = "denyPinRegistrationRequest";

  /// Deregister user method name
  static const String deregisterUserMethod = "deregisterUser";

  // Authentication

  /// Authenticate user method name
  static const String authenticateUser = 'authenticateUser';

  /// Get all not registered authenticators method name
  static const String getAllNotRegisteredAuthenticators =
      "getAllNotRegisteredAuthenticators";

  /// Get registered authenticators method name
  static const String getRegisteredAuthenticators =
      "getRegisteredAuthenticators";

  /// Get all authenticators method name
  static const String getAllAuthenticators = "getAllAuthenticators";

  /// Register authenticator method name
  static const String registerAuthenticator = "registerAuthenticator";

  /// Accept pin authentication request method name
  static const String acceptPinAuthenticationRequest =
      "acceptPinAuthenticationRequest";

  /// Deny pin authentication request method name
  static const String denyPinAuthenticationRequest =
      "denyPinAuthenticationRequest";

  /// Logout method name
  static const String logout = 'logout';
  static const String setPreferredAuthenticator = "setPreferredAuthenticator";
  static const String deregisterAuthenticator = "deregisterAuthenticator";

  // Fingerprint

  /// Accept fingerprint authentication request method name
  static const String acceptFingerprintAuthenticationRequest =
      'acceptFingerprintAuthenticationRequest';

  /// Deny fingerprint authentication request method name
  static const String denyFingerprintAuthenticationRequest =
      "denyFingerprintAuthenticationRequest";

  /// Fingerprint fallback to pin method name
  static const String fingerprintFallbackToPin = "fingerprintFallbackToPin";

  // OTP

  /// Handle mobile auth with OTP method name
  static const String handleMobileAuthWithOtp = "handleMobileAuthWithOtp";

  /// Accept OTP authentication request method name
  static const String acceptOtpAuthenticationRequest =
      "acceptOtpAuthenticationRequest";

  /// Deny OTP authentication request method name
  static const String denyOtpAuthenticationRequest =
      "denyOtpAuthenticationRequest";

  // Resources

  /// Get resource method name
  static const String getResource = "getResource";

  /// Get resource anonymous method name
  static const String getResourceAnonymous = "getResourceAnonymous";

  /// Get implicit resource method name
  static const String getImplicitResource = "getImplicitResource";

  /// Get unauthenticated resource method name
  static const String getUnauthenticatedResource = "getUnauthenticatedResource";

  // Other

  /// Get app to web single sign on method name
  static const String getAppToWebSingleSignOn = "getAppToWebSingleSignOn";
  static const String getAccessToken = "getAccessToken";
  static const String getAuthenticatedUserProfile =
      "getAuthenticatedUserProfile";

  /// Change pin method name
  static const String changePin = "changePin";
  static const String userProfiles = "userProfiles";
  static const String validatePinWithPolicy = "validatePinWithPolicy";

  // CustomRegistration

  /// Custom two step registration return success method name
  static const String customTwoStepRegistrationReturnSuccess =
      "customTwoStepRegistrationReturnSuccess";

  /// Custom two step registration return error method name
  static const String customTwoStepRegistrationReturnError =
      "customTwoStepRegistrationReturnError";

  //#endregion Onegini methods

  //#region Onegini events

  // Pin

  /// Open pin event name
  static const String eventOpenPin = "eventOpenPin";

  /// Open pin auth event name
  static const String eventOpenPinAuth = "eventOpenPinAuth";

  /// Open pin authenticator event name
  static const String eventOpenPinAuthenticator = "eventOpenPinAuthenticator";

  /// Close pin event name
  static const String eventClosePin = "eventClosePin";

  /// Close pin auth event name
  static const String eventClosePinAuth = "eventClosePinAuth";

  /// Next authentication attempt event name
  static const String eventNextAuthenticationAttempt =
      "eventNextAuthenticationAttempt";

  ///Handle url for registration
  static const String eventHandleRegisteredUrl = "eventHandleRegisteredUrl";

  // Fingerprint

  /// Open fingerprint auth event name
  static const String eventOpenFingerprintAuth = "eventOpenFingerprintAuth";

  /// Received fingerprint auth event name
  static const String eventReceivedFingerprintAuth =
      "eventReceivedFingerprintAuth";

  /// Show scanning fingerprint auth event name
  static const String eventShowScanningFingerprintAuth =
      "eventShowScanningFingerprintAuth";

  /// Close fingerprint auth event name
  static const String eventCloseFingerprintAuth = "eventCloseFingerprintAuth";

  // OTP

  /// Open auth OTP event name
  static const String eventOpenAuthOTP = "eventOpenAuthOtp";

  /// Cancel auth OTP event name
  static const String eventCancelAuthOTP = "eventCancelAuthOtp";

  /// Close auth OTP event name
  static const String eventCloseAuthOTP = "eventCloseAuthOtp";

  // Custom

  /// Open custom two step registration screen event name
  static const String openCustomTwoStepRegistrationScreen =
      "openCustomTwoStepRegistrationScreen";

  /// Error event name
  static const String eventError = "eventError";

//#endregion Onegini events
}
