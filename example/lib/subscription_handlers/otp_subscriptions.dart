import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/otp_event.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini_example/screens/auth_otp_screen.dart';

// Event Subscriptions related to Custom Registration
List<StreamSubscription<OWEvent>> initOtpSubscriptions(BuildContext context) {
  return [_getOpenAuthOtpSub(context), _getCloseAuthOtpSub(context)];
}

StreamSubscription<OWEvent> _getOpenAuthOtpSub(BuildContext context) {
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

StreamSubscription<OWEvent> _getCloseAuthOtpSub(BuildContext context) {
  return OWBroadcastHelper.createStream<CloseAuthOtpEvent>().listen((event) {
    Navigator.of(context).pop();
  });
}
