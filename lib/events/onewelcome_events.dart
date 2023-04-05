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
  openPinRegistration, // previously openPinRequestScreen; Called to open pin registration screen.
  closePinRegistration, // previously closePin; Called to open pin registration screen.
  openPinAuthentication, // previously openPinScreenAuth; Called to open pin authentication screen
  closePinAuthentication, // previously closePinAuth; Called to close pin authentication screen
  pinNotAllowed, // Called when the supplied pin is not allowed

  // Fingerprint
  openFingerprint, // previously openFingerprintScreen; Called to open fingerprint screen.
  closeFingerprint, // previously closeFingerprintScreen; Called to close fingerprint screen.
  showScanningFingerprint, // Called to scan fingerprint.
  receivedFingerprint, // Called when fingerprint was received.

  // CustomRegistration
  initCustomRegistration, // previously eventInitCustomRegistration; Called when customRegistration is initialized and a response should be given (only for two-step)
  finishCustomRegistration, // previously eventFinishCustomRegistration; Called when customRegistration finishes and a final response should be given

  // Authentication
  nextAuthenticationAttempt, // Called to attempt next authentication.

  /*
    Deleted events:
      - eventOther
      - openPinAuthenticator
      - eventError
  */
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
      case OWAction.receivedFingerprint:
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
