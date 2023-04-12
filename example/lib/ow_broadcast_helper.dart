import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_custom_registration_callback.dart';
import 'package:onegini/events/browser_event.dart';
import 'package:onegini/events/custom_registration_event.dart';
import 'package:onegini/events/fingerprint_event.dart';
import 'package:onegini/events/generic_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/otp_event.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/user_client.dart';
import 'package:onegini_example/components/display_toast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/auth_otp_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/fingerprint_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/otp_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/pin_request_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/pin_screen.dart';

class OWBroadcastHelper {
  static List<StreamSubscription<OWEvent>> initRegistrationListeners(BuildContext context) {
    var broadCastController = Onegini.instance.userClient.owEventStreamController;

    // Url Registration Related Events
    StreamSubscription<OWEvent> handleRegisteredUrlSub = broadCastController.stream.where((event) => event is HandleRegisteredUrlEvent).listen((event) {
      if (event is HandleRegisteredUrlEvent) {
        Onegini.instance.userClient.handleRegisteredUserUrl(event.url,
          signInType: WebSignInType.insideApp);
      }
    });

    // Pin Registration Related Events
    StreamSubscription<OWEvent> openPinSub = broadCastController.stream.where((event) => event is OpenPinRegistrationEvent).listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PinRequestScreen()),
      );
    });

    StreamSubscription<OWEvent> closePinSub =  broadCastController.stream.where((event) => event is ClosePinRegistrationEvent).listen((event) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });

    StreamSubscription<OWEvent> pinNotAllowedSub = broadCastController.stream.where((event) => event is PinNotAllowedEvent).listen((event) {
      if (event is PinNotAllowedEvent) {
        showFlutterToast("${event.error.message} Code: ${event.error.code}");
      }
    });

    // Custom Registration related events
    StreamSubscription<OWEvent> initCustomSub = broadCastController.stream.where((event) => event is InitCustomRegistrationEvent).listen((event) {
      if (event is InitCustomRegistrationEvent && event.providerId == "2-way-otp-api") {
        // a 2-way-otp does not require data for the initialization request
        OneginiCustomRegistrationCallback()
            .submitSuccessAction(event.providerId, null)
            .catchError((error) => {
              if (error is PlatformException)
                {showFlutterToast(error.message ?? "An error occuring while answering init custom registration")}
            });
      }
    });

    StreamSubscription<OWEvent> finishCustomSub = broadCastController.stream.where((event) => event is FinishCustomRegistrationEvent).listen((event) {
      if (event is FinishCustomRegistrationEvent && event.providerId == "2-way-otp-api") {
        // a 2-way-otp does not require data for the initialization request
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                  password: event.customInfo?.data, providerId: event.providerId)),
        );
      }
    });

    return [handleRegisteredUrlSub, openPinSub, closePinSub, pinNotAllowedSub, initCustomSub, finishCustomSub];
  }

  static List<StreamSubscription<OWEvent>> initAuthenticationListeners(BuildContext context) {
    var broadCastController = Onegini.instance.userClient.owEventStreamController;
    var pinScreenController = PinScreenController();
    var fingerprintOverlay = OverlayEntry(builder: (context) {
      return Container(
          color: Colors.black12.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    });

    // Pin Authentication related events
    StreamSubscription<OWEvent> openPinSub = broadCastController.stream.where((event) => event is OpenPinAuthenticationEvent).listen((event) {
      print("open pin auth:");
      print(context);
      print(pinScreenController);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinScreen(controller: pinScreenController)),
      );
    });

    StreamSubscription<OWEvent> closePinSub = broadCastController.stream.where((event) => event is ClosePinAuthenticationEvent).listen((event) {
      print("close pin auth");
      print(context);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });

    // Fingerprint Authentication related events
    StreamSubscription<OWEvent> openFingerprintSub = broadCastController.stream.where((event) => event is OpenFingerprintEvent).listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FingerprintScreen()),
      );
    });

    StreamSubscription<OWEvent> closeFingerprintSub = broadCastController.stream.where((event) => event is CloseFingerprintEvent).listen((event) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });

    StreamSubscription<OWEvent> showScanningFingerprintSub = broadCastController.stream.where((event) => event is ShowScanningFingerprintEvent).listen((event) {
      Overlay.of(context).insert(fingerprintOverlay);
    });

    StreamSubscription<OWEvent> receivedFingerprintSub = broadCastController.stream.where((event) => event is ReceivedFingerprintEvent).listen((event) {
      fingerprintOverlay.remove();
    });

    // Generic Authentication related events
    StreamSubscription<OWEvent> nextAuthenticationAttempt = broadCastController.stream.where((event) => event is NextAuthenticationAttemptEvent).listen((event) {
      if (event is NextAuthenticationAttemptEvent) {
        pinScreenController.clearState();
        showFlutterToast("failed attempts ${event.authenticationAttempt.failedAttempts} from ${event.authenticationAttempt.maxAttempts}");
      }
    });

    return [openPinSub, closePinSub, openFingerprintSub, closeFingerprintSub, showScanningFingerprintSub, receivedFingerprintSub, nextAuthenticationAttempt];
  }

  static List<StreamSubscription<OWEvent>> initOTPListeners(BuildContext context) {
    var broadCastController = Onegini.instance.userClient.owEventStreamController;

    StreamSubscription<OWEvent> openAuthOtpSub = broadCastController.stream.where((event) => event is OpenAuthOtpEvent).listen((event) {
      if (event is OpenAuthOtpEvent) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthOtpScreen(
                    message: event.message,
                  )),
        );
      }
    });

    StreamSubscription<OWEvent> closeAuthOtpSub = broadCastController.stream.where((event) => event is CloseAuthOtpEvent).listen((event) {
      Navigator.of(context).pop();
    });

    return [openAuthOtpSub, closeAuthOtpSub];
  }

  static void stopListening(List<StreamSubscription<OWEvent>> subscriptions) {
    subscriptions.forEach((element) { element.cancel(); });
  }
}
