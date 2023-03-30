import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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

  ///Called to handle registration URL
  void handleRegisteredUrl(BuildContext? buildContext, String url);

  /// Called to open OTP authentication.
  void openAuthOtp(BuildContext? buildContext, String message);

  /// Called to close OTP authentication.
  void closeAuthOtp(BuildContext? buildContext);

  /// Called to open pin registration screen.
  void openPinRequestScreen(BuildContext? buildContext);

  /// Called to open pin authentication screen.
  void openPinScreenAuth(BuildContext? buildContext);

  /// Called to open pin authentication screen.
  void openPinAuthenticator(BuildContext? buildContext);

  /// Called to attempt next authentication.
  void nextAuthenticationAttempt(
      BuildContext? buildContext, AuthenticationAttempt authenticationAttempt);

  /// Called to close pin registration screen.
  void closePin(BuildContext? buildContext);

  /// Called to close pin authentication screen.
  void closePinAuth(BuildContext? buildContext);

  /// Called to open fingerprint screen.
  void openFingerprintScreen(BuildContext? buildContext);

  /// Called to scan fingerprint.
  void showScanningFingerprint(BuildContext? buildContext);

  /// Called when fingerprint was received.
  void receivedFingerprint(BuildContext? buildContext);

  /// Called to close fingerprint screen.
  void closeFingerprintScreen(BuildContext? buildContext);

  /// Called when the InitCustomRegistration event occurs and a response should be given (only for two-step)
  void eventInitCustomRegistration(
      BuildContext? buildContext, OWCustomInfo? customInfo, String providerId);

  /// Called when the FinishCustomRegistration event occurs and a response should be given
  void eventFinishCustomRegistration(
      BuildContext? buildContext, OWCustomInfo? customInfo, String providerId);

  /// Called when error event was received.
  void eventError(BuildContext? buildContext, PlatformException error);

  /// Called when custom event was received.
  void eventOther(BuildContext? buildContext, Event event);

  void pinNotAllowed(OWOneginiError error);

  @override
  void n2fCloseAuthOtp() {
    closeAuthOtp(_context);
  }

  @override
  void n2fCloseFingerprintScreen() {
    closeFingerprintScreen(_context);
  }

  @override
  void n2fClosePin() {
    closePin(_context);
  }

  @override
  void n2fClosePinAuth() {
    closePinAuth(_context);
  }

  @override
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    eventFinishCustomRegistration(_context, customInfo, providerId);
  }

  @override
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    eventInitCustomRegistration(_context, customInfo, providerId);
  }

  @override
  void n2fHandleRegisteredUrl(String url) {
    print("hello from handleRegisteredUrl");
    handleRegisteredUrl(_context, url);
  }

  @override
  void n2fNextAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt) {
    nextAuthenticationAttempt(
        _context,
        AuthenticationAttempt(
            failedAttempts: authenticationAttempt.failedAttempts,
            maxAttempts: authenticationAttempt.maxAttempts,
            remainingAttempts: authenticationAttempt.remainingAttempts));
  }

  @override
  void n2fOpenAuthOtp(String? message) {
    openAuthOtp(_context, message != null ? message : "");
  }

  @override
  void n2fOpenFingerprintScreen() {
    openFingerprintScreen(_context);
  }

  @override
  void n2fOpenPinAuthenticator() {
    openPinAuthenticator(_context);
  }

  @override
  void n2fOpenPinRequestScreen() {
    openPinRequestScreen(_context);
  }

  @override
  void n2fOpenPinScreenAuth() {
    openPinScreenAuth(_context);
  }

  @override
  void n2fReceivedFingerprint() {
    receivedFingerprint(_context);
  }

  @override
  void n2fShowScanningFingerprint() {
    showScanningFingerprint(_context);
  }

  @override
  void n2fEventPinNotAllowed(OWOneginiError error) {
    pinNotAllowed(error);
  }
}
