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
  void n2fOpenPinRequestScreen() {
    // renamed OpenPinRegistrationEvent to OpenPinCreationEvent
    broadcastEvent(OpenPinRegistrationEvent());
  }

  @override
  void n2fClosePin() {
    // renamed ClosePinRegistrationEvent -> ClosePinCreationEvent
    broadcastEvent(ClosePinRegistrationEvent());
  }

  @override
  void n2fEventPinNotAllowed(OWOneginiError error) {
    broadcastEvent(PinNotAllowedEvent(error));
  }

  /// Custom Registration related events
  @override
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    broadcastEvent(FinishCustomRegistrationEvent(customInfo, providerId));
  }

  @override
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    broadcastEvent(InitCustomRegistrationEvent(customInfo, providerId));
  }

  /// Pin Authentication related events
  @override
  void n2fOpenPinScreenAuth() {
    broadcastEvent(OpenPinAuthenticationEvent());
  }

  @override
  void n2fClosePinAuth() {
    broadcastEvent(ClosePinAuthenticationEvent());
  }

  @override
  void n2fNextAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt) {
    // renamed from NextAuthenticationAttemptEvent to NextPinAuthenticationAttemptEvent
    broadcastEvent(NextAuthenticationAttemptEvent(authenticationAttempt));
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
