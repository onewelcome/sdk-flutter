// Wrapper for OneWelcome Events
abstract class OWEvent {
  OWAction action;
  OWEvent(this.action);
}

enum OWAction {
  // Browser
  handleRegisteredUrl, // Called to handle registration URL

  // Otp
  openAuthOtp, // Called to open OTP authentication screen
  closeAuthOtp, // Called to close OTP authentication screen

  // Pin
  openPinRegistration, // Called to open pin registration screen.
  closePinRegistration, // Called to open pin registration screen.
  openPinAuthentication, // Called to open pin authentication screen
  closePinAuthentication, // Called to close pin authentication screen
  pinNotAllowed, // Called when the supplied pin for registration is not allowed

  // Fingerprint
  openFingerprint, // Called to open fingerprint screen.
  closeFingerprint, // Called to close fingerprint screen.
  showScanningFingerprint, // Called to scan fingerprint.
  nextFingerprintAuthenticationAttempt, // Called when fingerprint was received but was incorrect.

  // CustomRegistration
  initCustomRegistration, // Called when customRegistration is initialized and a response should be given (only for two-step)
  finishCustomRegistration, // Called when customRegistration finishes and a final response should be given

  // Authentication
  nextAuthenticationAttempt, // Called to attempt next authentication.
}

extension OWActionExtension on OWAction {
  String get value {
    switch (this) {
      case OWAction.handleRegisteredUrl:
        return "handleRegisteredUrl";
      case OWAction.openAuthOtp:
        return "openAuthOtp";
      case OWAction.openPinRegistration:
        return "openPinRegistration";
      case OWAction.openPinAuthentication:
        return "openPinAuthentication";
      case OWAction.openFingerprint:
        return "openFingerprint";
      case OWAction.closeAuthOtp:
        return "closeAuthOtp";
      case OWAction.closePinRegistration:
        return "closePinRegistration";
      case OWAction.closePinAuthentication:
        return "closePinAuthentication";
      case OWAction.closeFingerprint:
        return "closeFingerprint";
      case OWAction.pinNotAllowed:
        return "pinNotAllowed";
      case OWAction.showScanningFingerprint:
        return "showScanningFingerprint";
      case OWAction.nextFingerprintAuthenticationAttempt:
        return "receivedFingerprint";
      case OWAction.initCustomRegistration:
        return "initCustomRegistration";
      case OWAction.finishCustomRegistration:
        return "finishCustomRegistration";
      case OWAction.nextAuthenticationAttempt:
        return "nextAuthenticationAttempt";
    }
  }
}
