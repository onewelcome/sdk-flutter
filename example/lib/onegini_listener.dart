// @dart = 2.10
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/model/authentication_attempt.dart';
import 'package:onegini/model/onegini_error.dart';
import 'package:onegini/model/onegini_event.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/user_client.dart';
import 'package:onegini_example/screens/auth_otp_screen.dart';
import 'package:onegini_example/screens/fingerprint_screen.dart';
import 'package:onegini_example/screens/pin_request_screen.dart';
import 'package:onegini_example/screens/pin_screen.dart';
import 'package:onegini/callbacks/onegini_custom_registration_callback.dart';

import 'screens/otp_screen.dart';

class OneginiListener extends OneginiEventListener {

  final PinScreenController pinScreenController = PinScreenController();

  @override
  void closePin(BuildContext buildContext) {
    if (Navigator.of(buildContext).canPop()) {
      Navigator.of(buildContext).pop();
    }
  }

  @override
  void openPinRequestScreen(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => PinRequestScreen()),
    );
  }

  @override
  void eventOther(BuildContext buildContext, Event event) {
    print(event.eventValue);
  }

  @override
  void eventError(BuildContext buildContext, PlatformException error) {
    showErrorToast("${error.message} Code: ${error.code} ");
  }

  @override
  void showError(BuildContext buildContext, OneginiError error) {
    showErrorToast("${error.message} Code: ${error.code} " ?? "Something went wrong");
  }

  @override
  void openPinScreenAuth(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => PinScreen(controller: pinScreenController)),
    );
  }

  @override
  void openPinAuthenticator(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(
          builder: (context) => PinRequestScreen(
                customAuthenticator: true,
              )),
    );
  }

  @override
  void nextAuthenticationAttempt(
      BuildContext buildContext, AuthenticationAttempt authenticationAttempt) {
    pinScreenController.clearState();
    Fluttertoast.showToast(
        msg:
            "failed attempts ${authenticationAttempt.failedAttempts} from ${authenticationAttempt.maxAttempts}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void closeFingerprintScreen(BuildContext buildContext) {
    print("close fingerprint");
    overlayEntry?.remove();
    if (Navigator.of(buildContext).canPop()) {
      Navigator.of(buildContext).pop();
    }
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
    overlayEntry?.remove();
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
    Overlay.of(buildContext)?.insert(overlayEntry);
  }

  OverlayEntry overlayEntry;

  @override
  void openAuthOtp(BuildContext buildContext, String message) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(
          builder: (context) => AuthOtpScreen(
                message: message,
              )),
    );
  }

  @override
  void closeAuthOtp(BuildContext buildContext) {
    Navigator.of(buildContext).pop();
  }

  @override
  void closePinAuth(BuildContext buildContext) {
    if (Navigator.of(buildContext).canPop()) {
      Navigator.of(buildContext).pop();
    }
  }

  @override
  void eventInitCustomRegistration(
    BuildContext buildContext, String data) {

    try {
      var response = jsonDecode(data);
      var providerId = response["providerId"];

      if (providerId == "2-way-otp-api") {
        // a 2-way-otp does not require data for the initialization request
        OneginiCustomRegistrationCallback()
          .submitSuccessAction(providerId, null)
          .catchError((error) => {
            if (error is PlatformException) {
              showErrorToast(error.message)
            }
          });
      }
    } on FormatException catch (error) {
      showErrorToast(error.message);
      return;
    }
  }

  @override
  void eventFinishCustomRegistration(
      BuildContext buildContext, String data) {

    try {
      var response = jsonDecode(data);
      var providerId = response["providerId"];

      if (providerId == "2-way-otp-api")
        Navigator.push(
          buildContext,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                    password: response["data"],
                    providerId: providerId
                  )),
        );
    } on FormatException catch (error) {
      showErrorToast(error.message);
      return;
    }
  }

  @override
  void handleRegisteredUrl(BuildContext buildContext, String url) async {
    await Onegini.instance.userClient.handleRegisteredUserUrl(buildContext, url,
        signInType: WebSignInType.insideApp);
  }

  void showErrorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 16.0);
  }
}
