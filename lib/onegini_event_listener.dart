import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/onegini_error.dart';

import 'constants/constants.dart';
import 'model/authentication_attempt.dart';
import 'model/onegini_event.dart';

/// Extend from this class to describe the events that will take place inside OneginiSDK
abstract class OneginiEventListener {
  /// A communication channel name
  static const channel_name = 'onegini_events';
  static const EventChannel _eventChannel = const EventChannel(channel_name);

  BuildContext? _context;

  /// Saves the build context
  set context(BuildContext? context) {
    _context = context;
  }

  /// Sets up listener.
  ///
  /// Call methods based on received event name.
  void listen() {
    _eventChannel.receiveBroadcastStream(channel_name).listen((event) {
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
        case Constants.fetchUserProfiles:
        default:
          if (event != null) {
            Event _event = eventFromJson(event);

            switch(_event.eventName) {
              case Constants.eventNextAuthenticationAttempt:
                nextAuthenticationAttempt(
                  _context, authenticationAttemptFromJson(_event.eventValue!));
                break;
              case Constants.eventOpenAuthOTP:
                openAuthOtp(_context, _event.eventValue!);
                break;
              case Constants.eventHandleRegisteredUrl:
                handleRegisteredUrl(_context, _event.eventValue!);
                break;
              case Constants.eventInitCustomRegistration:
                eventInitCustomRegistration(_context, _event.eventValue!);
                break;
              case Constants.eventFinishCustomRegistration:
                eventFinishCustomRegistration(_context, _event.eventValue!);
                break;
              case Constants.eventError:
                showError(_context, oneginiErrorFromJson(_event.eventValue!));
                break;
              default:
                eventOther(_context, _event);
                break;
            }
          }
      }
    }).onError((error) {
      eventError(_context, error);
    });
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
      BuildContext? buildContext, String data);

  /// Called when the FinishCustomRegistration event occurs and a response should be given
  void eventFinishCustomRegistration(
      BuildContext? buildContext, String data);

  /// Called when error event was received.
  void eventError(BuildContext? buildContext, PlatformException error);

  /// Called whenever error occured.
  void showError(BuildContext? buildContext, OneginiError? error);

  /// Called when custom event was received.
  void eventOther(BuildContext? buildContext, Event event);
}
