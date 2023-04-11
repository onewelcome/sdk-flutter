// @dart = 2.10

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/authentication_attempt.dart';
import 'package:onegini/model/onegini_event.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/pigeon.dart';
import 'package:onegini/user_client.dart';
import 'package:onegini_example/screens/auth_otp_screen.dart';
import 'package:onegini_example/screens/fingerprint_screen.dart';
import 'package:onegini_example/screens/pin_request_screen.dart';
import 'package:onegini_example/screens/pin_screen.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini/callbacks/onegini_custom_registration_callback.dart';

import 'screens/otp_screen.dart';

class OneginiListener extends OneginiEventListener {
  final PinScreenController pinScreenController = PinScreenController();

  // done
  @override
  void closePin(BuildContext buildContext) {
    // if (Navigator.of(buildContext).canPop()) {
    //   Navigator.of(buildContext).pop();
    // }
  }

  // done
  @override
  void openPinRequestScreen(BuildContext buildContext) {
    // Navigator.push(
    //   buildContext,
    //   MaterialPageRoute(builder: (context) => PinRequestScreen()),
    // );
  }

  // done
  @override
  void openPinScreenAuth(BuildContext buildContext) {
    // Navigator.push(
    //   buildContext,
    //   MaterialPageRoute(
    //       builder: (context) => PinScreen(controller: pinScreenController)),
    // );
  }
  
  // done
  @override
  void nextAuthenticationAttempt(
      BuildContext buildContext, AuthenticationAttempt authenticationAttempt) {
    // pinScreenController.clearState();
    // showFlutterToast(
    //     "failed attempts ${authenticationAttempt.failedAttempts} from ${authenticationAttempt.maxAttempts}");
  }

  // done
  @override
  void closeFingerprintScreen(BuildContext buildContext) {
    // print("close fingerprint");
    // overlayEntry?.remove();
    // if (Navigator.of(buildContext).canPop()) {
    //   Navigator.of(buildContext).pop();
    // }
  }

  // done
  @override
  void openFingerprintScreen(BuildContext buildContext) {
    // print("open fingerprint");
    // Navigator.push(
    //   buildContext,
    //   MaterialPageRoute(builder: (context) => FingerprintScreen()),
    // );
  }

  // done
  @override
  void receivedFingerprint(BuildContext buildContext) {
    // overlayEntry?.remove();
  }

  // done
  @override
  void showScanningFingerprint(BuildContext buildContext) {
    // overlayEntry = OverlayEntry(builder: (context) {
    //   return Container(
    //       color: Colors.black12.withOpacity(0.5),
    //       child: Center(
    //         child: CircularProgressIndicator(),
    //       ));
    // });
    // Overlay.of(buildContext)?.insert(overlayEntry);
  }

  OverlayEntry overlayEntry;

  // done
  @override
  void openAuthOtp(BuildContext buildContext, String message) {
    // Navigator.push(
    //   buildContext,
    //   MaterialPageRoute(
    //       builder: (context) => AuthOtpScreen(
    //             message: message,
    //           )),
    // );
  }

  // done
  @override
  void closeAuthOtp(BuildContext buildContext) {
    // Navigator.of(buildContext).pop();
  }

  // done
  @override
  void closePinAuth(BuildContext buildContext) {
    // if (Navigator.of(buildContext).canPop()) {
    //   Navigator.of(buildContext).pop();
    // }
  }

  // done
  @override
  void eventInitCustomRegistration(
      BuildContext buildContext, OWCustomInfo customInfo, String providerId) {
    // try {
    //   if (providerId == "2-way-otp-api") {
    //     // a 2-way-otp does not require data for the initialization request
    //     OneginiCustomRegistrationCallback()
    //         .submitSuccessAction(providerId, null)
    //         .catchError((error) => {
    //               if (error is PlatformException)
    //                 {showFlutterToast(error.message)}
    //             });
    //   }
    // } on FormatException catch (error) {
    //   showFlutterToast(error.message);
    //   return;
    // }
  }

  // done
  @override
  void eventFinishCustomRegistration(
      BuildContext buildContext, OWCustomInfo customInfo, String providerId) {
    // try {
    //   if (providerId == "2-way-otp-api")
    //     Navigator.push(
    //       buildContext,
    //       MaterialPageRoute(
    //           builder: (context) => OtpScreen(
    //               password: customInfo?.data, providerId: providerId)),
    //     );
    // } on FormatException catch (error) {
    //   showFlutterToast(error.message);
    //   return;
    // }
  }


  @override
  void handleRegisteredUrl(BuildContext buildContext, String url) async {
    // await Onegini.instance.userClient.handleRegisteredUserUrl(buildContext, url,
    //     signInType: WebSignInType.insideApp);
  }

  // done
  @override
  void pinNotAllowed(OWOneginiError error) {
    // showFlutterToast("${error.message} Code: ${error.code}");
  }
}
