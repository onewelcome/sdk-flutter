import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/pin_screen.dart';

// Event Subscriptions related to the creation of Pin
class PinAuthenticationSubscriptions {
  static List<StreamSubscription<OWEvent>> initSubscriptions(BuildContext context) {
    var pinScreenController = PinScreenController();

    return [_getOpenPinAuthSub(context, pinScreenController), _getClosePinAuthSub(context), _getNextPinAuthAttemptSub(pinScreenController)];
  }

  static StreamSubscription<OWEvent> _getOpenPinAuthSub(BuildContext context, PinScreenController pinScreenController) {
    return OWBroadcastHelper.createStream<OpenPinAuthenticationEvent>().listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinScreen(controller: pinScreenController)),
      );
    });
  }

  static StreamSubscription<OWEvent> _getClosePinAuthSub(BuildContext context) {
    return OWBroadcastHelper.createStream<ClosePinAuthenticationEvent>().listen((event) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  static StreamSubscription<OWEvent> _getNextPinAuthAttemptSub(PinScreenController pinScreenController) {
    return OWBroadcastHelper.createStream<NextPinAuthenticationAttemptEvent>().listen((event) {
      pinScreenController.clearState();
      showFlutterToast("failed attempts ${event.authenticationAttempt.failedAttempts} from ${event.authenticationAttempt.maxAttempts}");
    });
  }
}
