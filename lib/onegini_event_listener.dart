import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:onegini/events/browser_event.dart';
import 'package:onegini/events/custom_registration_event.dart';
import 'package:onegini/events/fingerprint_event.dart';
import 'package:onegini/events/generic_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/otp_event.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/pigeon.dart';
import 'model/authentication_attempt.dart';
import 'model/onegini_event.dart';

/// Extend from this class to describe the events that will take place inside OneginiSDK
abstract class OneginiEventListener implements NativeCallFlutterApi {
  BuildContext? _context;

  /// Saves the build context
  set context(BuildContext? context) {
    _context = context;
  }

  // done
  ///Called to handle registration URL
  void handleRegisteredUrl(BuildContext? buildContext, String url);

  // done
  /// Called to open OTP authentication.
  void openAuthOtp(BuildContext? buildContext, String message);

  // done
  /// Called to close OTP authentication.
  void closeAuthOtp(BuildContext? buildContext);

  // done
  /// Called to open pin registration screen.
  void openPinRequestScreen(BuildContext? buildContext);

  // done
  /// Called to open pin authentication screen.
  void openPinScreenAuth(BuildContext? buildContext);

  // done
  /// Called to attempt next authentication.
  void nextAuthenticationAttempt(
      BuildContext? buildContext, AuthenticationAttempt authenticationAttempt);

  // done
  /// Called to close pin registration screen.
  void closePin(BuildContext? buildContext);

  // done
  /// Called to close pin authentication screen.
  void closePinAuth(BuildContext? buildContext);

  // done
  /// Called to open fingerprint screen.
  void openFingerprintScreen(BuildContext? buildContext);

  // done
  /// Called to scan fingerprint.
  void showScanningFingerprint(BuildContext? buildContext);

  // done
  /// Called when fingerprint was received.
  void receivedFingerprint(BuildContext? buildContext);

  // done
  /// Called to close fingerprint screen.
  void closeFingerprintScreen(BuildContext? buildContext);

  // done
  /// Called when the InitCustomRegistration event occurs and a response should be given (only for two-step)
  void eventInitCustomRegistration(
      BuildContext? buildContext, OWCustomInfo? customInfo, String providerId);

  // done
  /// Called when the FinishCustomRegistration event occurs and a response should be given
  void eventFinishCustomRegistration(
      BuildContext? buildContext, OWCustomInfo? customInfo, String providerId);

  void pinNotAllowed(OWOneginiError error);

  @override
  void n2fCloseAuthOtp() {
    broadcastEvent(CloseAuthOtpEvent());

    closeAuthOtp(_context);
  }

  @override
  void n2fCloseFingerprintScreen() {
    broadcastEvent(CloseFingerprintEvent());

    closeFingerprintScreen(_context);
  }

  @override
  void n2fClosePin() {
    broadcastEvent(ClosePinRegistrationEvent());

    closePin(_context);
  }

  @override
  void n2fClosePinAuth() {
    broadcastEvent(ClosePinAuthenticationEvent());

    closePinAuth(_context);
  }

  @override
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    broadcastEvent(FinishCustomRegistrationEvent(customInfo, providerId));

    eventFinishCustomRegistration(_context, customInfo, providerId);
  }

  @override
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    broadcastEvent(InitCustomRegistrationEvent(customInfo, providerId));

    eventInitCustomRegistration(_context, customInfo, providerId);
  }

  @override
  void n2fHandleRegisteredUrl(String url) {
    broadcastEvent(HandleRegisteredUrlEvent(url));

    handleRegisteredUrl(_context, url);
  }

  @override
  void n2fNextAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt) {
    broadcastEvent(NextAuthenticationAttemptEvent(authenticationAttempt));

    nextAuthenticationAttempt(
        _context,
        AuthenticationAttempt(
            failedAttempts: authenticationAttempt.failedAttempts,
            maxAttempts: authenticationAttempt.maxAttempts,
            remainingAttempts: authenticationAttempt.remainingAttempts));
  }

  @override
  void n2fOpenAuthOtp(String? message) {
    broadcastEvent(OpenAuthOtpEvent(message ?? ""));

    openAuthOtp(_context, message ?? "");
  }

  @override
  void n2fOpenFingerprintScreen() {
    broadcastEvent(OpenFingerprintEvent());

    openFingerprintScreen(_context);
  }

  @override
  void n2fOpenPinRequestScreen() {
    broadcastEvent(OpenPinRegistrationEvent());

    openPinRequestScreen(_context);
  }

  @override
  void n2fOpenPinScreenAuth() {
    broadcastEvent(OpenPinAuthenticationEvent());

    openPinScreenAuth(_context);
  }

  @override
  void n2fReceivedFingerprint() {
    broadcastEvent(ReceivedFingerprintEvent());

    receivedFingerprint(_context);
  }

  @override
  void n2fShowScanningFingerprint() {
    broadcastEvent(ShowScanningFingerprintEvent());

    showScanningFingerprint(_context);
  }

  @override
  void n2fEventPinNotAllowed(OWOneginiError error) {
    broadcastEvent(PinNotAllowedEventEvent(error));

    pinNotAllowed(error);
  }

  void broadcastEvent(OWEvent event) {
    Onegini.instance.userClient.owEventStreamController.sink.add(event);
  }
}
