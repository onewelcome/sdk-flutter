import '../model/onegini_error.dart';

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
  static const String cancelRegistrationMethod = "cancelBrowserRegistration";

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

  static const String authenticateUserImplicitly = "authenticateUserImplicitly";

  static const String authenticateDevice = "authenticateDevice";

  // Other

  /// Get app to web single sign on method name
  static const String getAppToWebSingleSignOn = "getAppToWebSingleSignOn";
  static const String getAccessToken = "getAccessToken";
  static const String getRedirectUrl = "getRedirectUrl";
  static const String getAuthenticatedUserProfile =
      "getAuthenticatedUserProfile";

  /// Change pin method name
  static const String changePin = "changePin";
  static const String validatePinWithPolicy = "validatePinWithPolicy";

  /// Get User Profiles
  static const String getUserProfiles = "getUserProfiles";

  // CustomRegistration
  // Submit CustomRegistration Action success method
  static const String submitCustomRegistrationAction =
    "submitCustomRegistrationAction";

  // Submit CustomRegistration Action error method to cancel custom registration
  static const String cancelCustomRegistrationAction =
    "cancelCustomRegistrationAction";

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

  // Custom events

  /// Event triggered by the initRegistration needs to be responded (only used by two-step)
  static const String eventInitCustomRegistration = "eventInitCustomRegistration";

  /// Event triggered by the finishRegistration needs to be responded
  static const String eventFinishCustomRegistration = "eventFinishCustomRegistration";

  /// Error event name
  static const String eventError = "eventError";

  // Error codes

  //When the native type does not correspond with the expected dart type
  static OneginiError wrapperTypeError = OneginiError(
      message: "The native sdk returned an unexpected type", code: 8019);

//#endregion Onegini events
}
