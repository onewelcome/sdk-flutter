import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'model/authentication_attempt.dart';
import 'model/onegini_event.dart';

abstract class OneginiEventListener {
  static const chanel_name = 'onegini_events';
  static const EventChannel _eventChannel = const EventChannel(chanel_name);


  BuildContext? _context;

  set context(BuildContext context) {
    _context = context;
  }

  void listen() {
    _eventChannel.receiveBroadcastStream(chanel_name).listen((event) {
      switch (event) {
        case Constants.eventOpenPin: //2
          openPinRequestScreen(_context);
          break;
        case Constants.eventOpenPinAuth: //1
          openPinScreenAuth(_context);
          break;
        case Constants.eventOpenPinAuthenticator:
          openPinAuthenticator(_context);
          break;
        case Constants.eventClosePin:
          closePin(_context);
          break;
        case Constants.eventClosePinAuth:
          closePinAuth(_context);
          break;
        case Constants.eventOpenFingerprintAuth:
          openFingerprintScreen(_context);
          break;
        case Constants.eventShowScanningFingerprintAuth:
          showScanningFingerprint(_context);
          break;
        case Constants.eventReceivedFingerprintAuth:
          receivedFingerprint(_context);
          break;
        case Constants.eventCloseFingerprintAuth:
          closeFingerprintScreen(_context);
          break;
        case Constants.eventCloseAuthOTP:
          closeAuthOtp(_context);
          break;
        default:
          if (event != null) {
            Event _event = eventFromJson(event);
            if (_event.eventName == Constants.eventNextAuthenticationAttempt) {
              nextAuthenticationAttempt(
                  _context, authenticationAttemptFromJson(_event.eventValue!));
            }
            if (_event.eventName == Constants.eventOpenAuthOTP) {
              openAuthOtp(_context, _event.eventValue!);
            }
            if (_event.eventName ==
                Constants.openCustomTwoStepRegistrationScreen) {
              openCustomTwoStepRegistrationScreen(
                  _context, _event.eventValue!);
            }
            if (_event.eventName == Constants.eventError) {
              showError(_context, _event.eventValue);
            } else {
              eventOther(_context, _event);
            }
          }
      }
    }).onError((error) {
      eventError(_context, error);
    });
  }

  void openAuthOtp(BuildContext? buildContext, String message);

  void closeAuthOtp(BuildContext? buildContext);

  void openPinRequestScreen(BuildContext? buildContext);

  void openPinScreenAuth(BuildContext? buildContext);

  void openPinAuthenticator(BuildContext? buildContext);

  void nextAuthenticationAttempt(
      BuildContext? buildContext, AuthenticationAttempt authenticationAttempt);

  void closePin(BuildContext? buildContext);

  void closePinAuth(BuildContext? buildContext);

  void openFingerprintScreen(BuildContext? buildContext);

  void showScanningFingerprint(BuildContext? buildContext);

  void receivedFingerprint(BuildContext? buildContext);

  void closeFingerprintScreen(BuildContext? buildContext);

  void openCustomTwoStepRegistrationScreen(
      BuildContext? buildContext, String data);

  void eventError(BuildContext? buildContext, PlatformException error);

  void showError(BuildContext? buildContext, String? errorMessage);

  void eventOther(BuildContext? buildContext, Event event);
}
