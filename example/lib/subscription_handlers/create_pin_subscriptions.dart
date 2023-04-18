import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/pin_request_screen.dart';

// Event Subscriptions related to the creation of Pin
class CreatePinSubscriptions {
  static List<StreamSubscription<OWEvent>> initSubscriptions(BuildContext context) {
    return [_getOpenPinCreationSub(context), _getClosePinCreationSub(context), _getPinNotAllowedSub()];
  }

  static StreamSubscription<OWEvent> _getOpenPinCreationSub(BuildContext context) {
    return OWBroadcastHelper.createStream<OpenPinCreationEvent>().listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PinRequestScreen()),
      );
    });
  }

  static StreamSubscription<OWEvent> _getClosePinCreationSub(BuildContext context) {
    return OWBroadcastHelper.createStream<ClosePinCreationEvent>().listen((event) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  static StreamSubscription<OWEvent> _getPinNotAllowedSub() {
    return OWBroadcastHelper.createStream<PinNotAllowedEvent>().listen((event) {
      showFlutterToast("${event.error.message} Code: ${event.error.code}");
    });
  }
}
