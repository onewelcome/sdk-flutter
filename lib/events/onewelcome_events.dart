// Wrapper for OneWelcome Events
abstract class OWEvent {
  OWAction action;
  OWEvent(this.action);
}

enum OWAction {
  // Browser Registration
  handleRegisteredUrl, // Called to handle registration URL

  // Otp Mobile Authentication
  openAuthOtp, // Called to open OTP authentication screen
  closeAuthOtp, // Called to close OTP authentication screen

  // Pin Creation
  openPinCreation, // Called to open pin registration screen.
  closePinCreation, // Called to open pin registration screen.
  pinNotAllowed, // Called when the supplied pin for pin creation is not allowed

  // Pin Authentication
  openPinAuthentication, // Called to open pin authentication screen
  closePinAuthentication, // Called to close pin authentication screen
  nextPinAuthenticationAttempt, // Called to attempt next authentication.

  // Biometric Authentication
  startBiometric, // Called when new biometric auth request is made and to show biometric prompt.
  finishBiometric, // Called when biometric authentication finishes.

  // CustomRegistration
  initCustomRegistration, // Called when customRegistration is initialized and a response should be given (only for two-step)
  finishCustomRegistration, // Called when customRegistration finishes and a final response should be given
}

extension OWActionExtension on OWAction {
  String get value {
    switch (this) {
      // Browser Registration
      case OWAction.handleRegisteredUrl:
        return "handleRegisteredUrl";
      // Pin Creation
      case OWAction.openPinCreation:
        return "openPinCreation";
      case OWAction.closePinCreation:
        return "closePinCreation";
      case OWAction.pinNotAllowed:
        return "pinNotAllowed";
      // Pin Authentication
      case OWAction.openPinAuthentication:
        return "openPinAuthentication";
      case OWAction.closePinAuthentication:
        return "closePinAuthentication";
      case OWAction.nextPinAuthenticationAttempt:
        return "nextPinAuthenticationAttempt";
      // Biometric authentication
      case OWAction.startBiometric:
        return "startBiometric";
      case OWAction.finishBiometric:
        return "finishBiometric";
      // OTP Mobile authentication
      case OWAction.openAuthOtp:
        return "openAuthOtp";
      case OWAction.closeAuthOtp:
        return "closeAuthOtp";
      // Custom Registration
      case OWAction.initCustomRegistration:
        return "initCustomRegistration";
      case OWAction.finishCustomRegistration:
        return "finishCustomRegistration";
    }
  }
}
