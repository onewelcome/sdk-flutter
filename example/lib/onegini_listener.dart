import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/authentication_attempt.dart';
import 'package:onegini/model/onegini_event.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini_example/screens/fingerprint_screen.dart';
import 'package:onegini_example/screens/pin_screen.dart';

class OneginiListener extends OneginiEventListener {
  @override
  void closePin(BuildContext buildContext) {
    Navigator.of(buildContext).pop();
    Navigator.of(buildContext).canPop();
  }

  @override
  void openPinConfirmation(BuildContext buildContext) {
    print("open confirm screen");
    Navigator.of(buildContext)
      ..pop()
      ..push(
        MaterialPageRoute(
            builder: (context) => PinScreen(
                  confirmation: true,
                )),
      );
  }

  @override
  void openPinScreen(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => PinScreen()),
    );
  }

  @override
  void eventOther(BuildContext buildContext, Event event) {
    print(event.eventValue);
  }

  @override
  void eventError(BuildContext buildContext, PlatformException error) {
    print(error.message);
  }

  @override
  void openPinScreenAuth(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(
          builder: (context) => PinScreen(
                isAuth: true,
              )),
    );
  }

  @override
  void nextAuthenticationAttempt(
      BuildContext buildContext, AuthenticationAttempt authenticationAttempt) {
    print(authenticationAttempt.maxAttempts);
  }

  @override
  void closeFingerprintScreen(BuildContext buildContext) {
    print("close fingerprint");
    overlayEntry.remove();
    Navigator.of(buildContext).canPop();
  }

  @override
  void openFingerprintScreen(BuildContext buildContext) {
    print("open fingerprint");
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => FingerprintScreen()),
    );
  }

  @override
  void receivedFingerprint(BuildContext buildContext) {
    overlayEntry.remove();
  }

  @override
  void showScanningFingerprint(BuildContext buildContext) {
    overlayEntry = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black12.withOpacity(0.5),
          child: Center(
        child: CircularProgressIndicator(),
      ));
    });
    Overlay.of(buildContext).insert(overlayEntry);
  }

  OverlayEntry overlayEntry;
}
