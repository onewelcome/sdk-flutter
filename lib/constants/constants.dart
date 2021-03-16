
class Constants{

  /// Onegini methods
  static const String startAppMethod = 'startApp';
  static const String getPlatformVersion = 'getPlatformVersion';
  static const String getApplicationDetailsMethod = 'getApplicationDetails';
  static const String registrationMethod = 'registration';
  static const String logOutMethod = 'logOut';
  static const String getInfoMethod = "getInfo";
  static const String getSendPinMethod = "sendPin";
  static const String deregisterUserMethod = "deregisterUser";
  static const String getIdentityProvidersMethod = "getIdentityProviders";
  static const String getRegisteredAuthenticators = "getRegisteredAuthenticators";
  static const String registrationWithIdentityProviderMethod = "registrationWithIdentityProvider";
  static const String authenticateWithRegisteredAuthentication = "authenticateWithRegisteredAuthentication";
  static const String getClientResourceMethod = "getClientResource";
  static const String getImplicitUserDetailsMethod = "getImplicitUserDetails";
  static const String getSingleSignOnMethod = "singleSignOn";
  static const String pinAuthentication = 'pinAuthentication';
  static const String registerFingerprintAuthenticator = 'registerFingerprintAuthenticator';
  static const String fingerprintAuthentication = 'fingerprintAuthentication';
  static const String fingerprintActivationSensor = 'fingerprintActivationSensor';
  static const String cancelRegistrationMethod = "cancelRegistration";
  static const String cancelPinAuth = "cancelPinAuth";
  static const String changePin = "changePin";
  static const String otpQrCodeResponse ="otpQrCodeResponse";
  static const String acceptOTPAuth = "acceptOTPAuth";
  static const String denyOTPAuth = "denyOTPAuth";
  static const String isUserNotRegisteredFingerprint = "isUserNotRegisteredFingerprint";
  static const String getAllNotRegisteredAuthenticators = "getAllNotRegisteredAuthenticators";
  static const String registerAuthenticator = "registerAuthenticator";
  static const String getResourceAnonymous = "getResourceAnonymous";
  static const String getResource ="getResource";
  static const String getImplicitResource ="getImplicitResource";




  /// Onegini events
  static const String eventOpenPin = "eventOpenPin";
  static const String eventOpenPinAuth = "eventOpenPinAuth";
  static const String eventOpenPinConfirmation = "eventOpenPinConfirmation";
  static const String eventClosePin = "eventClosePin";
  static const String eventNextAuthenticationAttempt = "eventNextAuthenticationAttempt";

  static const String eventOpenFingerprintAuth = "eventOpenFingerprintAuth";
  static const String eventReceivedFingerprintAuth = "eventReceivedFingerprintAuth";
  static const String eventShowScanningFingerprintAuth = "eventShowScanningFingerprintAuth";
  static const String eventCloseFingerprintAuth = "eventCloseFingerprintAuth";

  static const String eventOpenAuthOTP = "eventOpenAuthOtp";
  static const String eventCancelAuthOTP = "eventCancelAuthOtp";
  static const String eventCloseAuthOTP = "eventCloseAuthOtp";
}