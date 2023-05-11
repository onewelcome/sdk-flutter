import 'dart:async';

import 'package:onegini/events/browser_event.dart';
import 'package:onegini/events/custom_registration_event.dart';
import 'package:onegini/events/fingerprint_event.dart';
import 'package:onegini/events/mobile_auth_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/otp_event.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini/onegini.gen.dart';

class OneginiEventListener implements NativeCallFlutterApi {
  final StreamController<OWEvent> broadCastController;

  OneginiEventListener(this.broadCastController);

  /// Browser Registration related events
  @override
  void n2fHandleRegisteredUrl(String url) {
    _broadcastEvent(HandleRegisteredUrlEvent(url));
  }

  /// Pin Creation related events
  @override
  void n2fOpenPinCreation() {
    _broadcastEvent(OpenPinCreationEvent());
  }

  @override
  void n2fClosePinCreation() {
    _broadcastEvent(ClosePinCreationEvent());
  }

  @override
  void n2fPinNotAllowed(OWOneginiError error) {
    _broadcastEvent(PinNotAllowedEvent(error));
  }

  /// Custom Registration related events
  @override
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    _broadcastEvent(InitCustomRegistrationEvent(customInfo, providerId));
  }

  @override
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId) {
    _broadcastEvent(FinishCustomRegistrationEvent(customInfo, providerId));
  }

  /// Pin Authentication related events
  @override
  void n2fOpenPinAuthentication() {
    _broadcastEvent(OpenPinAuthenticationEvent());
  }

  @override
  void n2fClosePinAuthentication() {
    _broadcastEvent(ClosePinAuthenticationEvent());
  }

  @override
  void n2fNextPinAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt) {
    _broadcastEvent(NextPinAuthenticationAttemptEvent(authenticationAttempt));
  }

  /// Fingerprint related events
  @override
  void n2fShowScanningFingerprint() {
    _broadcastEvent(ShowScanningFingerprintEvent());
  }

  @override
  void n2fOpenFingerprintScreen() {
    _broadcastEvent(OpenFingerprintEvent());
  }

  @override
  void n2fCloseFingerprintScreen() {
    _broadcastEvent(CloseFingerprintEvent());
  }

  @override
  void n2fNextFingerprintAuthenticationAttempt() {
    _broadcastEvent(NextFingerprintAuthenticationAttempt());
  }

  /// OTP Mobile authentication related events
  @override
  void n2fOpenAuthOtp(String? message) {
    _broadcastEvent(OpenAuthOtpEvent(message ?? ""));
  }

  @override
  void n2fStartMobileAuthPush(OWMobileAuthRequest request) {
    _broadcastEvent(StartMobileAuthWithPushEvent(request));
  }

  @override
  void n2fFinishMobileAuthPush() {
    _broadcastEvent(FinishMobileAuthWithPushEvent());
  }

  @override
  void n2fCloseAuthOtp() {
    _broadcastEvent(CloseAuthOtpEvent());
  }

  /// Helper method
  void _broadcastEvent(OWEvent event) {
    broadCastController.sink.add(event);
  }
}
