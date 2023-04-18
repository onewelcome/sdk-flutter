import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/otp_event.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/auth_otp_screen.dart';

// Event Subscriptions related to Custom Registration
class OtpSubscriptions {
  static List<StreamSubscription<OWEvent>> getSubscriptions(BuildContext context) {
    return [_getOpenAuthOtpSub(context), _getCloseAuthOtpSub(context)];
  }

  static StreamSubscription<OWEvent> _getOpenAuthOtpSub(BuildContext context) {
    return OWBroadcastHelper.createStream<OpenAuthOtpEvent>().listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AuthOtpScreen(
                  message: event.message,
                )),
      );
    });
  }

  static StreamSubscription<OWEvent> _getCloseAuthOtpSub(BuildContext context) {
    return OWBroadcastHelper.createStream<CloseAuthOtpEvent>().listen((event) {
      Navigator.of(context).pop();
    });
  }
}
