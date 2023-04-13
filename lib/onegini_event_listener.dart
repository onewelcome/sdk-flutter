import 'package:onegini/events/browser_event.dart';
import 'package:onegini/events/custom_registration_event.dart';
import 'package:onegini/events/fingerprint_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/otp_event.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/pigeon.dart';

class OneginiEventListener implements NativeCallFlutterApi {
  /// Browser Registration related events
  @override
  void n2fHandleRegisteredUrl(String url) {
    broadcastEvent(HandleRegisteredUrlEvent(url));
  }

  /// Pin Creation related events
  @override
  void n2fOpenPinCreation() {
    // renamed OpenPinRegistrationEvent to OpenPinCreationEvent
    broadcastEvent(OpenPinCreationEvent());
  }

  @override
  void n2fClosePinCreation() {
    // renamed ClosePinRegistrationEvent -> ClosePinCreationEvent
    broadcastEvent(ClosePinCreationEvent());
  }

  @override
  void n2fPinNotAllowed(OWOneginiError error) {
    broadcastEvent(PinNotAllowedEvent(error));
  }

  /// Custom Registration related events
  @override
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    broadcastEvent(InitCustomRegistrationEvent(customInfo, providerId));
  }

  @override
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    broadcastEvent(FinishCustomRegistrationEvent(customInfo, providerId));
  }

  /// Pin Authentication related events
  @override
  void n2fOpenPinAuthentication() {
    broadcastEvent(OpenPinAuthenticationEvent());
  }

  @override
  void n2fClosePinAuthentication() {
    broadcastEvent(ClosePinAuthenticationEvent());
  }

  @override
  void n2fNextPinAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt) {
    broadcastEvent(NextPinAuthenticationAttemptEvent(authenticationAttempt));
  }

  /// Fingerprint related events
  @override
  void n2fShowScanningFingerprint() {
    broadcastEvent(ShowScanningFingerprintEvent());
  }

  @override
  void n2fOpenFingerprintScreen() {
    broadcastEvent(OpenFingerprintEvent());
  }

  @override
  void n2fCloseFingerprintScreen() {
    broadcastEvent(CloseFingerprintEvent());
  }

  @override
  void n2fNextFingerprintAuthenticationAttempt() {
    broadcastEvent(NextFingerprintAuthenticationAttempt());
  }

  /// OTP Mobile authentication related events
  @override
  void n2fOpenAuthOtp(String? message) {
    broadcastEvent(OpenAuthOtpEvent(message ?? ""));
  }

  @override
  void n2fCloseAuthOtp() {
    broadcastEvent(CloseAuthOtpEvent());
  }

  /// Helper method
  void broadcastEvent(OWEvent event) {
    Onegini.instance.userClient.owEventStreamController.sink.add(event);
  }
}
